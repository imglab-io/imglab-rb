class Imglab::Utils
  NORMALIZE_PATH_PREFIX_REGEXP = Regexp.compile(/\/*$/)
  NORMALIZE_PATH_SUFFIX_REGEXP = Regexp.compile(/\A\/*/)

  def self.normalize_path(path)
    path.gsub(NORMALIZE_PATH_PREFIX_REGEXP, "").gsub(NORMALIZE_PATH_SUFFIX_REGEXP, "")
  end

  def self.normalize_params(params)
    params.map { |key, value| [dasherize(key), value] }.to_h
  end

  private

  def self.dasherize(value)
    value.to_s.gsub("_", "-")
  end
end
