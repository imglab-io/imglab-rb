module Imglab
  extend self

  # Returns a formatted URL `string` with the specified arguments.
  #
  # @param source [String, Imglab::Source] the source name or source object
  # @param path [String] the path where the resource is located
  # @param params [Hash] the query parameters that we want to use
  # @return [String] the formatted URL with the specified arguments
  # @raise [ArgumentError] when the source name or source parameter has a not expected type
  #
  # @example Creating a URL specifying source name as string
  #   Imglab.url("assets", "example.jpeg", width: 500, height: 600) #=> "https://assets.imglab-cdn.net/example.jpeg?width=500&height=600"
  # @example Creating a URL specifying a Imglab::Source
  #   Imglab.url(Imglab::Source.new("assets"), "example.jpeg", width: 500, height: 600) #=> "https://assets.imglab-cdn.net/example.jpeg?width=500&height=600"
  def url(source, path, params = {})
    case source
    when String
      url_for_source(Source.new(source), path, params)
    when Source
      url_for_source(source, path, params)
    else
      raise ArgumentError, "Invalid source name or source. A string or a #{Source.name} instance is expected"
    end
  end

  private

  def url_for_source(source, path, params)
    normalized_path = Url::Utils.normalize_path(path)
    normalized_params = Url::Utils.normalize_params(params)

    URI::Generic.new(
      source.scheme,
      nil,
      source.host,
      source.port,
      nil,
      File.join("/", source.path(encode_path(normalized_path))),
      nil,
      encode_params(source, normalized_path, normalized_params),
      nil
    ).to_s
  end

  def encode_path(path)
    if Url::Utils.web_uri?(path)
      encode_path_component(path)
    else
      path.split("/").map do |path_component|
        encode_path_component(path_component)
      end.join("/")
    end
  end

  def encode_path_component(path_component)
    ERB::Util.url_encode(path_component)
  end

  def encode_params(source, path, params)
    return encode_empty_params(source, path) if params.empty?

    if source.is_secure?
      signature = Signature.generate(source, path, URI.encode_www_form(params))

      URI.encode_www_form(params.merge(signature: signature))
    else
      URI.encode_www_form(params)
    end
  end

  def encode_empty_params(source, path)
    return unless source.is_secure?

    signature = Signature.generate(source, path)

    URI.encode_www_form(signature: signature)
  end
end
