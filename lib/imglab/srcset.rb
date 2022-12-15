module Imglab
  extend self

  DYNAMIC_CLASSES = [Array, Range].freeze

  DEFAULT_DPRS = [1, 2, 3, 4, 5, 6].freeze
  DEFAULT_WIDTHS = Sequence.sequence(100, 8192).freeze

  # Returns a formatted srcset `string` with the specified parameters.
  #
  # @param source [String, Imglab::Source] the source name or source object
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
  def srcset(source, path, params = {})
    params = Srcset::Utils.normalize_params(params)

    width, height, dpr = params.values_at("width", "height", "dpr")

    case
    when is_dynamic?(width)
      if is_dynamic?(dpr)
        raise ArgumentError, "dpr as #{dpr.class} is not allowed when width is Array or Range"
      end

      srcset_width(source, path, params)
    when width || height
      if is_dynamic?(height)
        raise ArgumentError, "height as #{height.class} is not allowed when width is not an Array or Range"
      end

      srcset_dpr(source, path, params.merge("dpr" => dprs(params)))
    else
      if is_dynamic?(dpr)
        raise ArgumentError, "dpr as #{dpr.class} is not allowed without specifying width or height"
      end

      srcset_width(source, path, params.merge("width" => DEFAULT_WIDTHS))
    end
  end

  private

  def dprs(params)
    is_dynamic?(params["dpr"]) ? params["dpr"] : DEFAULT_DPRS
  end

  def is_dynamic?(value)
    DYNAMIC_CLASSES.include?(value.class)
  end

  def srcset_dpr(source, path, params)
    Srcset::Utils.split_params_dpr(params).map do |split_params|
      "#{url(source, path, split_params)} #{split_params.fetch('dpr')}x"
    end.join(",\n")
  end

  def srcset_width(source, path, params)
    Srcset::Utils.split_params_width(params).map do |split_params|
      "#{url(source, path, split_params)} #{split_params.fetch('width')}w"
    end.join(",\n")
  end
end
