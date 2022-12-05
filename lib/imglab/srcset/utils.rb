module Imglab::Srcset
  module Utils
    NORMALIZE_KEYS = %w[dpr width]

    SPLIT_DPR_KEYS = %w[dpr quality]
    SPLIT_WIDTH_KEYS = %w[width height quality]

    # Returns normalized params, rejecting values with keys included in normalized keys and with empty arrays.
    #
    # @param params [Hash]
    # @return [Hash]
    def self.normalize_params(params)
      params.inject({}) do |normalized_params, (key, value)|
        normalized_params.merge(normalize_param(key.to_s, value))
      end
    end

    # Returns an array with the parameters to use in different URLs for a srcset split by dpr parameter.
    #
    # @param params [Hash]
    # @return [Array]
    def self.split_params_dpr(params)
      split_values(params, SPLIT_DPR_KEYS, params.fetch("dpr").size).map do |dpr, quality|
        params.merge(
          {"dpr" => dpr, "quality" => quality}.delete_if do |key, _value|
            !params.has_key?(key)
          end
        )
      end
    end

    # Returns an array with the parameters to use in different URLs for a srcset split by width parameter.
    #
    # @param params [Hash]
    # @return [Array]
    def self.split_params_width(params)
      split_values(params, SPLIT_WIDTH_KEYS, split_size(params.fetch("width"))).map do |width, height, quality|
        params.merge(
          {"width" => width, "height" => height, "quality" => quality}.delete_if do |key, value|
            !params.has_key?(key)
          end
        )
      end
    end

    private

    def self.normalize_param(key, value)
      case
      when NORMALIZE_KEYS.include?(key) && value == []
        {}
      else
        {key => value}
      end
    end

    def self.split_size(value)
      case value
      when Range
        Imglab::Sequence::DEFAULT_SIZE
      when Array
        value.size
      end
    end

    def self.split_values(params, keys, size)
      values = keys.map { |key| split_value(key, params[key], size) }
      values.first.zip(*values[1..-1])
    end

    def self.split_value(key, value, size)
      case
      when key == "dpr" && value.instance_of?(Range)
        value.to_a
      when value.instance_of?(Range)
        Imglab::Sequence.sequence(value.first, value.last, size)
      when value.instance_of?(Array)
        value
      else
        Array.new(size, value)
      end
    end
  end
end
