require "erb"

require "imglab/version"
require "imglab/source"
require "imglab/signature"
require "imglab/color"
require "imglab/position"
require "imglab/utils"

module Imglab
  SRCSET_DEFAULT_DPRS = [1, 2, 3, 4, 5, 6]
  SRCSET_DEFAULT_WIDTHS = [64, 128, 256, 512, 1024, 2048, 4096, 8192]

  # Returns a formatted URL `string` with the specified arguments.
  #
  # @param source_name_or_source [String, Imglab::Source] the source name or source object
  # @param path [String] the path where the resource is located
  # @param params [Hash] the query parameters that we want to use
  # @return [String] the formatted URL with the specified arguments
  # @raise [ArgumentError] when the source name or source parameter has a not expected type.
  #
  # @example Creating a URL specifying source name as string
  #   Imglab.url("assets", "example.jpeg", width: 500, height: 600) #=> "https://assets.imglab-cdn.net/example.jpeg?width=500&height=600"
  # @example Creating a URL specifying a Imglab::Source
  #   Imglab.url(Imglab::Source.new("assets"), "example.jpeg", width: 500, height: 600) #=> "https://assets.imglab-cdn.net/example.jpeg?width=500&height=600"
  def self.url(source_name_or_source, path, params = {})
    case source_name_or_source
    when String
      url_for_source(Source.new(source_name_or_source), path, params)
    when Source
      url_for_source(source_name_or_source, path, params)
    else
      raise ArgumentError.new("Invalid source name or source. A string or a #{Imglab::Source.name} instance is expected.")
    end
  end

  def self.srcset(source_name_or_source, path, params = {})
    case
    when params[:width].instance_of?(Array)
      srcset_widths(source_name_or_source, path, params[:width], params)
    when params[:width] || params[:height]
      dprs = params[:dpr].instance_of?(Array) ? params[:dpr] : SRCSET_DEFAULT_DPRS

      srcset_dprs(source_name_or_source, path, dprs, params)
    else
      srcset_widths(source_name_or_source, path, SRCSET_DEFAULT_WIDTHS, params)
    end
  end

  private

  def self.srcset_widths(source_name_or_source, path, widths, params)
    widths.map do |width|
      "#{url(source_name_or_source, path, params.merge(width: width))} #{width}w"
    end.join(",\n")
  end

  def self.srcset_dprs(source_name_or_source, path, dprs, params)
    dprs.map do |dpr|
      "#{url(source_name_or_source, path, params.merge(dpr: dpr))} #{dpr}x"
    end.join(",\n")
  end

  def self.url_for_source(source, path, params)
    normalized_path = Utils.normalize_path(path)
    normalized_params = Utils.normalize_params(params)

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

  def self.encode_path(path)
    if Utils.web_uri?(path)
      encode_path_component(path)
    else
      path.split("/").map do |path_component|
        encode_path_component(path_component)
      end.join("/")
    end
  end

  def self.encode_path_component(path_component)
    ERB::Util.url_encode(path_component)
  end

  def self.encode_params(source, path, params)
    return encode_empty_params(source, path) if params.empty?

    if source.is_secure?
      signature = Signature.generate(source, path, URI.encode_www_form(params))

      URI.encode_www_form(params.merge(signature: signature))
    else
      URI.encode_www_form(params)
    end
  end

  def self.encode_empty_params(source, path)
    if source.is_secure?
      signature = Signature.generate(source, path)

      URI.encode_www_form(signature: signature)
    else
      nil
    end
  end
end
