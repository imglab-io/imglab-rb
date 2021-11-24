class Imglab::Source
  DEFAULT_HTTPS = true
  DEFAULT_HOST = "cdn.imglab.io"
  DEFAULT_SUBDOMAINS = false

  attr_reader :name, :https, :port, :secure_key, :secure_salt, :subdomains

  def initialize(name, host: DEFAULT_HOST, https: DEFAULT_HTTPS, port: nil, secure_key: nil, secure_salt: nil, subdomains: DEFAULT_SUBDOMAINS)
    @name = name
    @host = host
    @https = https
    @port = port
    @secure_key = secure_key
    @secure_salt = secure_salt
    @subdomains = subdomains
  end

  def scheme
    @https ? "https" : "http"
  end

  def host
    @subdomains ? "#{@name}.#{@host}" : @host
  end

  def path(path)
    @subdomains ? path : File.join(@name, path)
  end

  def secure?
    @secure_key && @secure_salt
  end

  def inspect
    "#<#{self.class.name}:#{object_id} @name=#{@name.inspect}, @host=#{@host.inspect}, @https=#{@https.inspect}, @port=#{@port.inspect}, @subdomains=#{@subdomains.inspect}>"
  end
end
