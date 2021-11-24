require "test_helper"

describe Imglab::Color do
  describe ".color" do
    it "returns rgb color as string" do
      assert_equal Imglab::Color.color(255, 0, 0), "255,0,0"
      assert_equal Imglab::Color.color(0, 255, 0), "0,255,0"
      assert_equal Imglab::Color.color(0, 0, 255), "0,0,255"

      assert_equal Imglab::Color.color(0, 255, 255), "0,255,255"
      assert_equal Imglab::Color.color(255, 0, 255), "255,0,255"
      assert_equal Imglab::Color.color(255, 255, 0), "255,255,0"

      assert_equal Imglab::Color.color(0, 0, 0), "0,0,0"
      assert_equal Imglab::Color.color(255, 255, 255), "255,255,255"
      assert_equal Imglab::Color.color(1, 2, 3), "1,2,3"
    end

    it "returns rgba color as string" do
      assert_equal Imglab::Color.color(255, 0, 0, 0), "255,0,0,0"
      assert_equal Imglab::Color.color(0, 255, 0, 0), "0,255,0,0"
      assert_equal Imglab::Color.color(0, 0, 255, 0), "0,0,255,0"
      assert_equal Imglab::Color.color(0, 0, 0, 255), "0,0,0,255"

      assert_equal Imglab::Color.color(0, 255, 255, 255), "0,255,255,255"
      assert_equal Imglab::Color.color(255, 0, 255, 255), "255,0,255,255"
      assert_equal Imglab::Color.color(255, 255, 0, 255), "255,255,0,255"
      assert_equal Imglab::Color.color(255, 255, 255, 0), "255,255,255,0"

      assert_equal Imglab::Color.color(0, 0, 0, 0), "0,0,0,0"
      assert_equal Imglab::Color.color(255, 255, 255, 255), "255,255,255,255"
      assert_equal Imglab::Color.color(1, 2, 3, 4), "1,2,3,4"
    end

    it "returns named color as string" do
      assert_equal Imglab::Color.color("blue"), "blue"
      assert_equal Imglab::Color.color("black"), "black"
      assert_equal Imglab::Color.color("white"), "white"
    end

    it "raises an argument error when the rgb color is invalid" do
      assert_raises(ArgumentError) { Imglab::Color.color(-1, 255, 255) }
      assert_raises(ArgumentError) { Imglab::Color.color(255, -1, 255) }
      assert_raises(ArgumentError) { Imglab::Color.color(255, 255, -1) }

      assert_raises(ArgumentError) { Imglab::Color.color(256, 255, 255) }
      assert_raises(ArgumentError) { Imglab::Color.color(255, 256, 255) }
      assert_raises(ArgumentError) { Imglab::Color.color(255, 255, 256) }

      assert_raises(ArgumentError) { Imglab::Color.color("255", 255, 255) }
      assert_raises(ArgumentError) { Imglab::Color.color(255, "255", 255) }
      assert_raises(ArgumentError) { Imglab::Color.color(255, 255, "255") }
    end

    it "raises an argument error when the rgba color is invalid" do
      assert_raises(ArgumentError) { Imglab::Color.color(-1, 255, 255, 255) }
      assert_raises(ArgumentError) { Imglab::Color.color(255, -1, 255, 255) }
      assert_raises(ArgumentError) { Imglab::Color.color(255, 255, -1, 255) }
      assert_raises(ArgumentError) { Imglab::Color.color(255, 255, 255, -1) }

      assert_raises(ArgumentError) { Imglab::Color.color(256, 255, 255, 255) }
      assert_raises(ArgumentError) { Imglab::Color.color(255, 256, 255, 255) }
      assert_raises(ArgumentError) { Imglab::Color.color(255, 255, 256, 255) }
      assert_raises(ArgumentError) { Imglab::Color.color(255, 255, 255, 256) }

      assert_raises(ArgumentError) { Imglab::Color.color("255", 255, 255, 255) }
      assert_raises(ArgumentError) { Imglab::Color.color(255, "255", 255, 255) }
      assert_raises(ArgumentError) { Imglab::Color.color(255, 255, "255", 255) }
      assert_raises(ArgumentError) { Imglab::Color.color(255, 255, 255, "255") }
    end

    it "raises an argument error when the named color is invalid" do
      assert_raises(ArgumentError) { Imglab::Color.color("blues") }
      assert_raises(ArgumentError) { Imglab::Color.color(:blue) }
    end
  end
end
