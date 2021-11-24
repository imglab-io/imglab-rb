require "base64"
require "openssl"

class Imglab::Signature
  def self.generate(source, path, encoded_params = nil)
    decoded_secure_key = Base64.decode64(source.secure_key)
    decoded_secure_salt = Base64.decode64(source.secure_salt)

    data = "#{decoded_secure_salt}/#{path}"
    data = encoded_params ? "#{data}?#{encoded_params}" : data

    hmac = OpenSSL::HMAC.digest(OpenSSL::Digest.new("sha256"), decoded_secure_key, data)

    Base64.urlsafe_encode64(hmac).tr("=", "")
  end
end
