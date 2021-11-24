require "test_helper"

describe Imglab::Signature do
  before do
    @secure_key = "ixUd9is/LDGBw6NPfLCGLjO/WraJlHdytC1+xiIFj22mXAWs/6R6ws4gxSXbDcUHMHv0G+oiTgyfMVsRS2b3"
    @secure_salt = "c9G9eYKCeWen7vkEyV1cnr4MZkfLI/yo6j72JItzKHjMGDNZKqPFzRtup//qiT51HKGJrAha6Gv2huSFLwJr"
  end

  describe ".generate" do
    it "returns signature with encoded params" do
      source = Imglab::Source.new("assets", secure_key: @secure_key, secure_salt: @secure_salt)
      signature = Imglab::Signature.generate(source, "example.jpeg", URI.encode_www_form(width: 200, height: 300, format: "png"))

      assert_equal signature, "VJ159IlBl_AlN59QWvyJov5SlQXlrZNpXgDJLJgzP8g"
    end

    it "returns signature without encoded params" do
      source = Imglab::Source.new("assets", secure_key: @secure_key, secure_salt: @secure_salt)
      signature = Imglab::Signature.generate(source, "example.jpeg")

      assert_equal signature, "aRgmnJ-7b2A0QLxXpR3cqrHVYmCfpRCOglL-nsp7SdQ"
    end
  end
end
