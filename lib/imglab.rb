require "erb"

require "imglab/version"
require "imglab/source"
require "imglab/signature"
require "imglab/color"
require "imglab/position"
require "imglab/sequence"
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
  # @raise [ArgumentError] when the source name or source parameter has a not expected type
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

  # Returns a string with a formatted list of URLs as expected by the `srcset` attribute value of an HTML `<img>` tag.
  #
  # @param source_name_or_source [String, Imglab::Source] the source name or source object
  # @param path [String] the path where the resource is located
  # @param params [Hash] the query parameters that we want to use
  # @return [String] the srcset value as a list of formatted URLs with the specified arguments
  # @raise [ArgumentError] when the source name or source parameter has a not expected type or params are using unexpected values
  #
  # @example Creating a srcset with three different device pixel ratios:
  #   Imglab.srcset("assets", "example.jpeg", width: 500, dpr: [1, 2, 3]) #=> "https://assets.imglab-cdn.net/example.jpeg?width=500&dpr=1 1x,\n..."
  # @example Creating a srcset with three different width sizes:
  #   Imglab.srcset("assets", "example.jpeg", width: [400, 800, 1200], format: "webp") #=> "https://assets.imglab-cdn.net/example.jpeg?width=400&format=webp 400w,\n..."
  def self.srcset(source_name_or_source, path, params = {})
    case
    when params[:width].instance_of?(Array)
      if params[:dpr].instance_of?(Array)
        raise ArgumentError.new("dpr as array is not allowed when width array is used.")
      end

      srcset_width(source_name_or_source, path, params)
    when params[:width] || params[:height]
      if params[:height].instance_of?(Array)
        raise ArgumentError.new("height as array is not allowed when width is not an array too.")
      end

      dprs = params[:dpr].instance_of?(Array) ? params[:dpr] : SRCSET_DEFAULT_DPRS

      srcset_dpr(source_name_or_source, path, params.merge(dpr: dprs))
    else
      if params[:dpr].instance_of?(Array)
        raise ArgumentError.new("dpr as array is not allowed without specifying a width or height.")
      end

      # TODO: Maybe this exception is not necessary because it makes sense to use a range of qualities
      if params[:quality].instance_of?(Array)
        raise ArgumentError.new("quality as array is not allowed without specifying a width or height.")
      end

      srcset_width(source_name_or_source, path, params.merge(width: SRCSET_DEFAULT_WIDTHS))
    end
  end

  private

  def self.srcset_width(source_name_or_source, path, params)
    srcset_split_params(params, [:width, :height, :quality]).map do |split_params|
      "#{url(source_name_or_source, path, split_params)} #{split_params[:width]}w"
    end.join(",\n")
  end

  def self.srcset_dpr(source_name_or_source, path, params)
    srcset_split_params(params, [:dpr, :quality]).map do |split_params|
      "#{url(source_name_or_source, path, split_params)} #{split_params[:dpr]}x"
    end.join(",\n")
  end

  def self.srcset_split_params(params, split_keys)
    params[split_keys[0]].map.with_index do |_, i|
      split_keys.inject(params) do |split_params, split_key|
        if params[split_key].instance_of?(Array)
          if params[split_key][i]
            split_params.merge(split_key => params[split_key][i])
          else
            split_params.delete(split_key)
            split_params
          end
        else
          split_params
        end
      end
    end
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
