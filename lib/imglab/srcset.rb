module Imglab
  extend self

  DEFAULT_DPRS = [1, 2, 3, 4, 5, 6]
  DEFAULT_WIDTHS = [64, 128, 256, 512, 1024, 2048, 4096, 8192]

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
  def srcset(source_name_or_source, path, params = {})
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

      dprs = params[:dpr].instance_of?(Array) ? params[:dpr] : DEFAULT_DPRS

      srcset_dpr(source_name_or_source, path, params.merge(dpr: dprs))
    else
      if params[:dpr].instance_of?(Array)
        raise ArgumentError.new("dpr as array is not allowed without specifying a width or height.")
      end

      # TODO: Maybe this exception is not necessary because it makes sense to use a range of qualities
      if params[:quality].instance_of?(Array)
        raise ArgumentError.new("quality as array is not allowed without specifying a width or height.")
      end

      srcset_width(source_name_or_source, path, params.merge(width: DEFAULT_WIDTHS))
    end
  end

  private

  def srcset_width(source_name_or_source, path, params)
    srcset_split_params(params, [:width, :height, :quality]).map do |split_params|
      "#{url(source_name_or_source, path, split_params)} #{split_params[:width]}w"
    end.join(",\n")
  end

  def srcset_dpr(source_name_or_source, path, params)
    srcset_split_params(params, [:dpr, :quality]).map do |split_params|
      "#{url(source_name_or_source, path, split_params)} #{split_params[:dpr]}x"
    end.join(",\n")
  end

  def srcset_split_params(params, split_keys)
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
end
