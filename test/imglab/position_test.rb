require "test_helper"

describe Imglab::Position do
  describe ".position" do
    it "returns expected position as string" do
      assert_equal Imglab::Position.position("left"), "left"
      assert_equal Imglab::Position.position("center"), "center"
      assert_equal Imglab::Position.position("right"), "right"

      assert_equal Imglab::Position.position("top"), "top"
      assert_equal Imglab::Position.position("middle"), "middle"
      assert_equal Imglab::Position.position("bottom"), "bottom"
    end

    it "returns expected horizontal vertical position as string" do
      assert_equal Imglab::Position.position("left", "top"), "left,top"
      assert_equal Imglab::Position.position("left", "middle"), "left,middle"
      assert_equal Imglab::Position.position("left", "bottom"), "left,bottom"

      assert_equal Imglab::Position.position("center", "top"), "center,top"
      assert_equal Imglab::Position.position("center", "middle"), "center,middle"
      assert_equal Imglab::Position.position("center", "bottom"), "center,bottom"

      assert_equal Imglab::Position.position("right", "top"), "right,top"
      assert_equal Imglab::Position.position("right", "middle"), "right,middle"
      assert_equal Imglab::Position.position("right", "bottom"), "right,bottom"
    end

    it "returns expected vertical horizontal position as string" do
      assert_equal Imglab::Position.position("top", "left"), "top,left"
      assert_equal Imglab::Position.position("top", "center"), "top,center"
      assert_equal Imglab::Position.position("top", "right"), "top,right"

      assert_equal Imglab::Position.position("middle", "left"), "middle,left"
      assert_equal Imglab::Position.position("middle", "center"), "middle,center"
      assert_equal Imglab::Position.position("middle", "right"), "middle,right"

      assert_equal Imglab::Position.position("bottom", "left"), "bottom,left"
      assert_equal Imglab::Position.position("bottom", "center"), "bottom,center"
      assert_equal Imglab::Position.position("bottom", "right"), "bottom,right"
    end

    it "raises an argument error when the position is invalid" do
      assert_raises(ArgumentError) { Imglab::Position.position("lefts") }
      assert_raises(ArgumentError) { Imglab::Position.position(:left) }
    end

    it "raises an argument error when the horizontal vertical position is invalid" do
      assert_raises(ArgumentError) { Imglab::Position.position("left", "left") }
      assert_raises(ArgumentError) { Imglab::Position.position("left", "center") }
      assert_raises(ArgumentError) { Imglab::Position.position("left", "right") }

      assert_raises(ArgumentError) { Imglab::Position.position("center", "center") }
      assert_raises(ArgumentError) { Imglab::Position.position("center", "left") }
      assert_raises(ArgumentError) { Imglab::Position.position("center", "right") }

      assert_raises(ArgumentError) { Imglab::Position.position("right", "right") }
      assert_raises(ArgumentError) { Imglab::Position.position("right", "left") }
      assert_raises(ArgumentError) { Imglab::Position.position("right", "center") }

      assert_raises(ArgumentError) { Imglab::Position.position("top", "top") }
      assert_raises(ArgumentError) { Imglab::Position.position("top", "middle") }
      assert_raises(ArgumentError) { Imglab::Position.position("top", "bottom") }

      assert_raises(ArgumentError) { Imglab::Position.position("middle", "middle") }
      assert_raises(ArgumentError) { Imglab::Position.position("middle", "top") }
      assert_raises(ArgumentError) { Imglab::Position.position("middle", "bottom") }

      assert_raises(ArgumentError) { Imglab::Position.position("bottom", "bottom") }
      assert_raises(ArgumentError) { Imglab::Position.position("bottom", "top") }
      assert_raises(ArgumentError) { Imglab::Position.position("bottom", "middle") }
    end
  end
end
