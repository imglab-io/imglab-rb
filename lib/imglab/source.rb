class Imglab::Source
  DEFAULT_HTTPS = true
  DEFAULT_HOST = "imglab-cdn.net".freeze
  DEFAULT_SUBDOMAINS = true

  attr_reader :name, :https, :port, :secure_key, :secure_salt, :subdomains

  # Returns a Imglab::Source instance with the specified options for the source.
  #
  # @param name [String] the name of the source.
  # @param host [String] the host where the imglab server is located, only for imglab on-premises.
  # @param https [Boolean] specify if the source should use https or not.
  # @param port [Integer] the port where the imglab server is located, only for imglab on-premises.
  # @param secure_key [String] the source secure key.
  # @param secure_salt [String] the source secure salt.
  # @param subdomains [Boolean] specify if the source should use subdomains instead of paths to build the host name, only for imglab on-premises.
  # @return [Imglab::Source] with the specified options.
  def initialize(name, host: DEFAULT_HOST, https: DEFAULT_HTTPS, port: nil, secure_key: nil, secure_salt: nil, subdomains: DEFAULT_SUBDOMAINS)
    @name = name
    @host = host
    @https = https
    @port = port
    @secure_key = secure_key
    @secure_salt = secure_salt
    @subdomains = subdomains
  end

  # Returns the URI scheme to be used with the source ("http" or "https").
  #
  # @return [String]
  def scheme
    @https ? "https" : "http"
  end

  # Returns the host to be used with the source.
  #
  # @return [String]
  def host
    @subdomains ? "#{@name}.#{@host}" : @host
  end

  # Returns the path to be used with the source.
  #
  # @param path [String]
  # @return [String]
  def path(path)
    @subdomains ? path : File.join(@name, path)
  end

  # Returns if the source is secure or not.
  #
  # @return [Boolean]
  def is_secure?
    !!(@secure_key && @secure_salt)
  end

  # Overrided inspect method to don't show sensitive attributes like secure_key and secure_salt.
  #
  # @return [String]
  def inspect
    "#<#{self.class.name}:#{object_id} @name=#{@name.inspect}, @host=#{@host.inspect}, @https=#{@https.inspect}, @port=#{@port.inspect}, @subdomains=#{@subdomains.inspect}>"
  end
end
