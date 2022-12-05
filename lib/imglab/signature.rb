require "base64"
require "openssl"

module Imglab::Signature
  extend self

  # Returns a generated signature for a source, path and encoded parameters.
  #
  # @param source [Imglab::Source] the source used to generate the signature.
  # @param path [String] the path of the resource.
  # @param encoded_params [String] encoded query params of the URL to generate the signature.
  # @return [String]
  def generate(source, path, encoded_params = nil)
    decoded_secure_key = Base64.decode64(source.secure_key)
    decoded_secure_salt = Base64.decode64(source.secure_salt)

    data = "#{decoded_secure_salt}/#{path}"
    data = encoded_params ? "#{data}?#{encoded_params}" : data

    digest = OpenSSL::HMAC.digest(OpenSSL::Digest.new("sha256"), decoded_secure_key, data)

    Base64.urlsafe_encode64(digest).tr("=", "")
  end
end
