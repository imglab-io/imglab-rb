require "test_helper"

describe Imglab::Utils do
  describe ".normalize_path" do
    it "returns normalized path" do
      assert_equal Imglab::Utils.normalize_path(""), ""
      assert_equal Imglab::Utils.normalize_path("example.jpeg"), "example.jpeg"
      assert_equal Imglab::Utils.normalize_path("/example.jpeg"), "example.jpeg"
      assert_equal Imglab::Utils.normalize_path("//example.jpeg"), "example.jpeg"
      assert_equal Imglab::Utils.normalize_path("example.jpeg/"), "example.jpeg"
      assert_equal Imglab::Utils.normalize_path("example.jpeg//"), "example.jpeg"
      assert_equal Imglab::Utils.normalize_path("/example.jpeg/"), "example.jpeg"
      assert_equal Imglab::Utils.normalize_path("//example.jpeg//"), "example.jpeg"
      assert_equal Imglab::Utils.normalize_path("subfolder/example.jpeg"), "subfolder/example.jpeg"
      assert_equal Imglab::Utils.normalize_path("/subfolder/example.jpeg"), "subfolder/example.jpeg"
      assert_equal Imglab::Utils.normalize_path("//subfolder/example.jpeg"), "subfolder/example.jpeg"
      assert_equal Imglab::Utils.normalize_path("subfolder/example.jpeg/"), "subfolder/example.jpeg"
      assert_equal Imglab::Utils.normalize_path("subfolder/example.jpeg//"), "subfolder/example.jpeg"
      assert_equal Imglab::Utils.normalize_path("/subfolder/example.jpeg/"), "subfolder/example.jpeg"
      assert_equal Imglab::Utils.normalize_path("//subfolder/example.jpeg//"), "subfolder/example.jpeg"
    end
  end

  describe ".normalize_params" do
    it "returns normalized params" do
      assert_equal Imglab::Utils.normalize_params({}), {}
      assert_equal Imglab::Utils.normalize_params(width: 200, height: 300), {"width" => 200, "height" => 300}
      assert_equal Imglab::Utils.normalize_params(trim: "color", trim_color: "orange"), {"trim" => "color", "trim-color" => "orange"}
      assert_equal Imglab::Utils.normalize_params(trim: "color", "trim_color": "orange"), {"trim" => "color", "trim-color" => "orange"}
    end
  end
end
