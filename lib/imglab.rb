require "imglab/version"
require "imglab/source"
require "imglab/signature"
require "imglab/color"
require "imglab/position"
require "imglab/utils"

module Imglab
  # Returns a formatted URL `string` with the specified arguments.
  #
  # @param source_name_or_source [String, Imglab::Source] the source name or source object
  # @param path [String] the path where the resource is located
  # @param params [Hash] the query parameters that we want to use
  # @return [String] the formatted URL with the specified arguments
  # @raise [ArgumentError] when the source name or source parameter has a not expected type.
  #
  # @example Creating a URL specifying source name as string
  #   Imglab.url("assets", "example.jpeg", width: 500, height: 600) #=> "https://cdn.imglab.io/assets/example.jpeg?width=500&height=600"
  # @example Creating a URL specifying a Imglab::Source
  #   Imglab.url(Imglab::Source.new("assets"), "example.jpeg", width: 500, height: 600) #=> "https://cdn.imglab.io/assets/example.jpeg?width=500&height=600"
  def self.url(source_name_or_source, path, params = {})
    case source_name_or_source
    when String
      url_for_source(Source.new(source_name_or_source), path, params)
    when Source
      url_for_source(source_name_or_source, path, params)
    else
      raise ArgumentError.new("Invalid source name or source. A string or #{Imglab::Source.name} is expected.")
    end
  end

  private

  def self.url_for_source(source, path, params)
    normalized_path = Utils.normalize_path(path)
    normalized_params = Utils.normalize_params(params)

    URI::Generic.new(
      source.scheme,
      nil,
      source.host,
      source.port,
      nil,
      File.join("/", source.path(normalized_path)),
      nil,
      encode_params(source, normalized_path, normalized_params),
      nil
    ).to_s
  end

  def self.encode_params(source, path, params)
    return encode_empty_params(source, path) if params.empty?

    if source.secure?
      signature = Signature.generate(source, path, URI.encode_www_form(params))

      URI.encode_www_form(params.merge(signature: signature))
    else
      URI.encode_www_form(params)
    end
  end

  def self.encode_empty_params(source, path)
    if source.secure?
      signature = Signature.generate(source, path)

      URI.encode_www_form(signature: signature)
    else
      nil
    end
  end
end
