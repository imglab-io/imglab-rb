module Imglab::Url
  module Utils
    extend self

    NORMALIZE_PATH_PREFIX_REGEXP = Regexp.compile(/\A\/*/)
    NORMALIZE_PATH_SUFFIX_REGEXP = Regexp.compile(/\/*$/)

    WEB_URI_SCHEMES = %w[https http].freeze

    BASE64_SUFFIX = "64".freeze
    EXPIRES_ALIASES = %W[expires expires#{BASE64_SUFFIX}].freeze

    # Returns a normalized path where suffix and prefix slashes are removed.
    #
    # @param path [String]
    # @return [String]
    def normalize_path(path)
      path.gsub(NORMALIZE_PATH_PREFIX_REGEXP, "").gsub(NORMALIZE_PATH_SUFFIX_REGEXP, "")
    end

    # Returns normalized params, transforming keys with undercores to hyphens, and values
    # to Base64 if necessary.
    #
    # @param params [Hash]
    # @return [Hash]
    def normalize_params(params)
      params.each_with_object({}) do |(key, value), normalized_params|
        normalized_params.merge!(normalize_param(dasherize(key), value))
      end
    end

    # Returns a boolean value indicating whether a string is a valid HTTP/HTTPS URI or not.
    #
    # @param uri [String]
    # @return [Boolean]
    def web_uri?(uri)
      WEB_URI_SCHEMES.include?(URI.parse(uri).scheme)
    rescue URI::Error
      false
    end

    private

    def dasherize(value)
      value.to_s.gsub("_", "-")
    end

    def normalize_param(key, value)
      case
      when EXPIRES_ALIASES.include?(key) && value.instance_of?(Time)
        try_encode_base64_param(key, value.to_i)
      when value != nil
        try_encode_base64_param(key, value)
      else
        { key => "" }
      end
    end

    def try_encode_base64_param(key, value)
      if value != "" && key.end_with?(BASE64_SUFFIX)
        return { key => Base64.urlsafe_encode64(value.to_s).delete("=") }
      end

      { key => value }
    end
  end
end
