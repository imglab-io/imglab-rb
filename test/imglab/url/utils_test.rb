require "test_helper"

describe Imglab::Url::Utils do
  describe ".normalize_path" do
    it "returns normalized path" do
      assert_equal Imglab::Url::Utils.normalize_path(""), ""
      assert_equal Imglab::Url::Utils.normalize_path("example.jpeg"), "example.jpeg"
      assert_equal Imglab::Url::Utils.normalize_path("/example.jpeg"), "example.jpeg"
      assert_equal Imglab::Url::Utils.normalize_path("//example.jpeg"), "example.jpeg"
      assert_equal Imglab::Url::Utils.normalize_path("example.jpeg/"), "example.jpeg"
      assert_equal Imglab::Url::Utils.normalize_path("example.jpeg//"), "example.jpeg"
      assert_equal Imglab::Url::Utils.normalize_path("/example.jpeg/"), "example.jpeg"
      assert_equal Imglab::Url::Utils.normalize_path("//example.jpeg//"), "example.jpeg"
      assert_equal Imglab::Url::Utils.normalize_path("subfolder/example.jpeg"), "subfolder/example.jpeg"
      assert_equal Imglab::Url::Utils.normalize_path("/subfolder/example.jpeg"), "subfolder/example.jpeg"
      assert_equal Imglab::Url::Utils.normalize_path("//subfolder/example.jpeg"), "subfolder/example.jpeg"
      assert_equal Imglab::Url::Utils.normalize_path("subfolder/example.jpeg/"), "subfolder/example.jpeg"
      assert_equal Imglab::Url::Utils.normalize_path("subfolder/example.jpeg//"), "subfolder/example.jpeg"
      assert_equal Imglab::Url::Utils.normalize_path("/subfolder/example.jpeg/"), "subfolder/example.jpeg"
      assert_equal Imglab::Url::Utils.normalize_path("//subfolder/example.jpeg//"), "subfolder/example.jpeg"
    end
  end

  describe ".normalize_params" do
    it "returns normalized params" do
      assert_equal Imglab::Url::Utils.normalize_params({}), {}
      assert_equal Imglab::Url::Utils.normalize_params(width: 200, height: 300), { "width" => 200, "height" => 300 }
      assert_equal Imglab::Url::Utils.normalize_params(trim: "color", trim_color: "orange"), { "trim" => "color", "trim-color" => "orange" }
      assert_equal Imglab::Url::Utils.normalize_params(:"trim" => "color", :"trim-color" => "orange"), { "trim" => "color", "trim-color" => "orange" }
      assert_equal Imglab::Url::Utils.normalize_params("trim" => "color", "trim_color" => "orange"), { "trim" => "color", "trim-color" => "orange" }
      assert_equal Imglab::Url::Utils.normalize_params(width: 200, expires: 1464096368), { "width" => 200, "expires" => 1464096368 }
      assert_equal Imglab::Url::Utils.normalize_params(width: 200, expires: "1464096368"), { "width" => 200, "expires" => "1464096368" }
      assert_equal Imglab::Url::Utils.normalize_params(width: 200, expires: Time.at(1464096368)), { "width" => 200, "expires" => 1464096368 }
    end
  end

  describe ".web_uri?" do
    it "returns boolean value indicating whether string is a valid HTTP/HTTPS URI or not" do
      assert Imglab::Url::Utils.web_uri?("https://assets.com/example.jpeg")
      assert Imglab::Url::Utils.web_uri?("http://assets.com/example.jpeg")
      assert Imglab::Url::Utils.web_uri?("HTTPS://assets.com/example.jpeg")
      assert Imglab::Url::Utils.web_uri?("HTTP://assets.com/example.jpeg")

      refute Imglab::Url::Utils.web_uri?("")
      refute Imglab::Url::Utils.web_uri?("example.jpeg")
      refute Imglab::Url::Utils.web_uri?("/example.jpeg")
      refute Imglab::Url::Utils.web_uri?("https/example.jpeg")
      refute Imglab::Url::Utils.web_uri?("http/example.jpeg")
      refute Imglab::Url::Utils.web_uri?("/https/example.jpeg")
      refute Imglab::Url::Utils.web_uri?("/http/example.jpeg")
    end
  end
end
