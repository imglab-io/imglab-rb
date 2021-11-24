require "test_helper"

describe Imglab::Source do
  describe "new" do
    it "returns source instance with default values" do
      source = Imglab::Source.new("assets")

      assert_equal source.name, "assets"
      assert_equal source.host, Imglab::Source::DEFAULT_HOST
      assert_equal source.https, Imglab::Source::DEFAULT_HTTPS
      assert_nil source.port, nil
      assert_nil source.secure_key, nil
      assert_nil source.secure_salt, nil
      assert_equal source.subdomains, Imglab::Source::DEFAULT_SUBDOMAINS
    end

    it "returns source instance expected optional values" do
      assert_equal Imglab::Source.new("assets", host: "imglab.net").host, "imglab.net"
      assert_equal Imglab::Source.new("assets", https: false).https, false
      assert_equal Imglab::Source.new("assets", port: 8080).port, 8080
      assert_equal Imglab::Source.new("assets", secure_key: "secure-key").secure_key, "secure-key"
      assert_equal Imglab::Source.new("assets", secure_salt: "secure-salt").secure_salt, "secure-salt"
      assert_equal Imglab::Source.new("assets", subdomains: true).subdomains, true
    end
  end

  describe "#scheme" do
    it "returns correct scheme" do
      assert_equal Imglab::Source.new("assets").scheme, "https"
      assert_equal Imglab::Source.new("assets", https: true).scheme, "https"
      assert_equal Imglab::Source.new("assets", https: false).scheme, "http"
    end
  end

  describe "#host" do
    it "returns correct host" do
      assert_equal Imglab::Source.new("assets").host, "cdn.imglab.io"
      assert_equal Imglab::Source.new("assets", subdomains: false).host, "cdn.imglab.io"
      assert_equal Imglab::Source.new("assets", subdomains: false, host: "imglab.net").host, "imglab.net"
      assert_equal Imglab::Source.new("assets", subdomains: true).host, "assets.cdn.imglab.io"
      assert_equal Imglab::Source.new("assets", subdomains: true, host: "imglab.net").host, "assets.imglab.net"
    end
  end

  describe "#path" do
    it "returns correct path" do
      assert_equal Imglab::Source.new("assets").path("example.jpeg"), "assets/example.jpeg"
      assert_equal Imglab::Source.new("assets").path("subfolder/example.jpeg"), "assets/subfolder/example.jpeg"
      assert_equal Imglab::Source.new("assets", subdomains: false).path("example.jpeg"), "assets/example.jpeg"
      assert_equal Imglab::Source.new("assets", subdomains: false).path("subfolder/example.jpeg"), "assets/subfolder/example.jpeg"
      assert_equal Imglab::Source.new("assets", subdomains: true).path("example.jpeg"), "example.jpeg"
      assert_equal Imglab::Source.new("assets", subdomains: true).path("subfolder/example.jpeg"), "subfolder/example.jpeg"
    end
  end

  describe "#secure?" do
    it "returns if source is secure or not" do
      refute Imglab::Source.new("assets").secure?
      refute Imglab::Source.new("assets", secure_key: "secure-key").secure?
      assert Imglab::Source.new("assets", secure_key: "secure-key", secure_salt: "secure_salt").secure?
    end
  end
end
