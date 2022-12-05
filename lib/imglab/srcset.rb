module Imglab
  extend self

  DEFAULT_DPRS = [1, 2, 3, 4, 5, 6].freeze
  DEFAULT_WIDTHS = Sequence.sequence(100, 8192).freeze

  #  Returns a formatted srcset `string` with the specified parameters.
  #
  # @param source_name_or_source [String, Imglab::Source] the source name or source object
  # @param path [String] the path where the resource is located
  # @param params [Hash] the query parameters that we want to use
  # @return [String] the srcset value as a list of formatted URLs with the specified arguments
  # @raise [ArgumentError] when the source name or source parameter has a not expected type or params are using unexpected values
  #
  # @example Creating a srcset with three different device pixel ratios:
  #   Imglab.srcset("assets", "example.jpeg", width: 500, dpr: [1, 2, 3]) #=> "https://assets.imglab-cdn.net/example.jpeg?width=500&dpr=1 1x,\n..."
  # @example Creating a srcset with three different device pixel ratios using a range:
  #   Imglab.srcset("assets", "example.jpeg", width: 500, dpr: 1..3) #=> "https://assets.imglab-cdn.net/example.jpeg?width=500&dpr=1 1x,\n..."
  # @example Creating a srcset with three different width sizes:
  #   Imglab.srcset("assets", "example.jpeg", width: [400, 800, 1200], format: "webp") #=> "https://assets.imglab-cdn.net/example.jpeg?width=400&format=webp 400w,\n..."
  # @example Creating a srcset with a range of width sizes:
  #   Imglab.srcset("assets", "example.jpeg", width: 400..1200, format: "webp") #=> "https://assets.imglab-cdn.net/example.jpeg?width=400&format=webp 400w,\n..."
  def srcset(source_name_or_source, path, params = {})
    params = Srcset::Utils.normalize_params(params)

    case
    when params["width"].is_a?(Enumerable)
      if params["dpr"].is_a?(Enumerable)
        raise ArgumentError, "dpr as enumerable is not allowed when width enumerable is used"
      end

      srcset_width(source_name_or_source, path, params)
    when params["width"] || params["height"]
      if params["height"].is_a?(Enumerable)
        raise ArgumentError, "height as enumerable is not allowed when width is not an enumerable too"
      end

      srcset_dpr(source_name_or_source, path, params.merge("dpr" => dprs(params)))
    else
      if params["dpr"].is_a?(Enumerable)
        raise ArgumentError, "dpr as enumerable is not allowed without specifying a width or height"
      end

      srcset_width(source_name_or_source, path, params.merge("width" => DEFAULT_WIDTHS))
    end
  end

  private

  def dprs(params)
    if params["dpr"].is_a?(Enumerable)
      params["dpr"]
    else
      DEFAULT_DPRS
    end
  end

  def srcset_dpr(source_name_or_source, path, params)
    Srcset::Utils.split_params_dpr(params).map do |split_params|
      "#{url(source_name_or_source, path, split_params)} #{split_params.fetch('dpr')}x"
    end.join(",\n")
  end

  def srcset_width(source_name_or_source, path, params)
    Srcset::Utils.split_params_width(params).map do |split_params|
      "#{url(source_name_or_source, path, split_params)} #{split_params.fetch('width')}w"
    end.join(",\n")
  end
end
