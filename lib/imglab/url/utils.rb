module Imglab::Url
  module Utils
    extend self

    NORMALIZE_PATH_PREFIX_REGEXP = Regexp.compile(/\A\/*/)
    NORMALIZE_PATH_SUFFIX_REGEXP = Regexp.compile(/\/*$/)

    WEB_URI_SCHEMES = %w[https http].freeze

    # Returns a normalized path where suffix and prefix slashes are removed.
    #
    # @param path [String]
    # @return [String]
    def normalize_path(path)
      path.gsub(NORMALIZE_PATH_PREFIX_REGEXP, "").gsub(NORMALIZE_PATH_SUFFIX_REGEXP, "")
    end

    # Returns normalized params, transforming keys with undercores to hyphens.
    #
    # @param params [Hash]
    # @return [Hash]
    def normalize_params(params)
      params.inject({}) do |normalized_params, value|
        normalized_params.merge(normalize_param(dasherize(value[0]), value[1]))
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
      when key == "expires" && value.instance_of?(Time)
        { key => value.to_i }
      when value == nil
        { key => "" }
      else
        { key => value }
      end
    end
  end
end
