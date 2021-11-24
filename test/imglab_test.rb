require "test_helper"

describe Imglab do
  include Imglab::Color
  include Imglab::Position

  before do
    @secure_key = "ixUd9is/LDGBw6NPfLCGLjO/WraJlHdytC1+xiIFj22mXAWs/6R6ws4gxSXbDcUHMHv0G+oiTgyfMVsRS2b3"
    @secure_salt = "c9G9eYKCeWen7vkEyV1cnr4MZkfLI/yo6j72JItzKHjMGDNZKqPFzRtup//qiT51HKGJrAha6Gv2huSFLwJr"
  end

  describe ".url using source name" do
    it "returns url without params" do
      url = Imglab.url("assets", "example.jpeg")

      assert_equal url, "https://cdn.imglab.io/assets/example.jpeg"
    end

    it "returns url with params" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, format: "png")

      assert_equal url, "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&format=png"
    end

    it "returns url with params using string path" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, watermark: "example.svg", format: "png")

      assert_equal url, "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&watermark=example.svg&format=png"
    end

    it "returns url with params using string path with inline params" do
      url =
        Imglab.url("assets", "example.jpeg",
          width: 200,
          height: 300,
          watermark: "example.svg?width=100&format=png",
          format: "png"
        )

      assert_equal url, "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&watermark=example.svg%3Fwidth%3D100%26format%3Dpng&format=png"
    end

    it "returns url with params using rgb color" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, background_color: color(255, 128, 122))

      assert_equal url, "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&background-color=255%2C128%2C122"
    end

    it "returns url with params using rgba color" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, background_color: color(255, 128, 122, 128))

      assert_equal url, "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&background-color=255%2C128%2C122%2C128"
    end

    it "returns url with params using named color" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, background_color: color("blue"))

      assert url == "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&background-color=blue"
    end

    it "returns url with params using horizontal and vertical position" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, mode: "crop", crop: position("left", "bottom"))

      assert_equal url, "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&mode=crop&crop=left%2Cbottom"
    end

    it "returns url with params using vertical and horizontal position" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, mode: "crop", crop: position("bottom", "left"))

      assert_equal url, "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&mode=crop&crop=bottom%2Cleft"
    end

    it "returns url with params using position" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, mode: "crop", crop: position("left"))

      assert_equal url, "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&mode=crop&crop=left"
    end

    it "returns url with params using url method with source" do
      source = Imglab::Source.new("assets")

      url =
        Imglab.url(
          "assets",
          "example.jpeg",
          width: 200,
          height: 300,
          watermark: Imglab.url(source, "example.svg", width: 100, format: "png"),
          format: "png"
        )

      assert_equal url, "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&watermark=https%3A%2F%2Fcdn.imglab.io%2Fassets%2Fexample.svg%3Fwidth%3D100%26format%3Dpng&format=png"
    end

    it "returns url with params using url method with source name" do
      url =
        Imglab.url(
          "assets",
          "example.jpeg",
          width: 200,
          height: 300,
          watermark: Imglab.url("assets", "example.svg", width: 100, format: "png"),
          format: "png"
        )

      assert_equal url, "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&watermark=https%3A%2F%2Fcdn.imglab.io%2Fassets%2Fexample.svg%3Fwidth%3D100%26format%3Dpng&format=png"
    end

    it "returns url with params using symbols with underscores" do
      url = Imglab.url("assets", "example.jpeg", trim: "color", trim_color: "orange")

      assert_equal url, "https://cdn.imglab.io/assets/example.jpeg?trim=color&trim-color=orange"
    end

    it "returns url with params using symbols with hyphens" do
      url = Imglab.url("assets", "example.jpeg", :"trim" => "color", :"trim-color" => "orange")

      assert_equal url, "https://cdn.imglab.io/assets/example.jpeg?trim=color&trim-color=orange"
    end

    it "returns url with path starting with slash" do
      url = Imglab.url("assets", "/example.jpeg", width: 200, height: 300, format: "png")

      assert_equal url, "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&format=png"
    end

    it "returns url with path starting and ending with slash" do
      url = Imglab.url("assets", "/example.jpeg/", width: 200, height: 300, format: "png")

      assert_equal url, "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&format=png"
    end

    it "returns url with subfolder path starting with slash" do
      url = Imglab.url("assets", "/subfolder/example.jpeg", width: 200, height: 300, format: "png")

      assert_equal url, "https://cdn.imglab.io/assets/subfolder/example.jpeg?width=200&height=300&format=png"
    end

    it "returns url with subdfolder path starting and ending with slash" do
      url = Imglab.url("assets", "/subfolder/example.jpeg/", width: 200, height: 300, format: "png")

      assert_equal url, "https://cdn.imglab.io/assets/subfolder/example.jpeg?width=200&height=300&format=png"
    end
  end

  describe ".url using source" do
    it "returns url without params" do
      url = Imglab.url(Imglab::Source.new("assets"), "example.jpeg")

      assert_equal url, "https://cdn.imglab.io/assets/example.jpeg"
    end

    it "returns url with params" do
      url = Imglab.url(Imglab::Source.new("assets"), "example.jpeg", width: 200, height: 300, format: "png")

      assert_equal url, "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&format=png"
    end

    it "returns url with params using string path" do
      url = Imglab.url(Imglab::Source.new("assets"), "example.jpeg", width: 200, height: 300, watermark: "example.svg", format: "png")

      assert_equal url, "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&watermark=example.svg&format=png"
    end

    it "returns url with params using string path with inline params" do
      url =
        Imglab.url(
          Imglab::Source.new("assets"),
          "example.jpeg",
          width: 200,
          height: 300,
          watermark: "example.svg?width=100&format=png",
          format: "png"
        )

      assert_equal url, "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&watermark=example.svg%3Fwidth%3D100%26format%3Dpng&format=png"
    end

    it "returns url with params using url with source" do
      source = Imglab::Source.new("assets")

      url =
        Imglab.url(
          source,
          "example.jpeg",
          width: 200,
          height: 300,
          watermark: Imglab.url(source, "example.svg", width: 100, format: "png"),
          format: "png"
        )

      assert_equal url, "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&watermark=https%3A%2F%2Fcdn.imglab.io%2Fassets%2Fexample.svg%3Fwidth%3D100%26format%3Dpng&format=png"
    end

    it "returns url with params using url method with source name" do
      source = Imglab::Source.new("assets")

      url =
        Imglab.url(
          source,
          "example.jpeg",
          width: 200,
          height: 300,
          watermark: Imglab.url("assets", "example.svg", width: 100, format: "png"),
          format: "png"
        )

      assert_equal url, "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&watermark=https%3A%2F%2Fcdn.imglab.io%2Fassets%2Fexample.svg%3Fwidth%3D100%26format%3Dpng&format=png"
    end

    it "returns url with params using symbols with underscores" do
      url = Imglab.url(Imglab::Source.new("assets"), "example.jpeg", trim: "color", trim_color: "orange")

      assert_equal url, "https://cdn.imglab.io/assets/example.jpeg?trim=color&trim-color=orange"
    end

    it "returns url with params using atoms with hyphens" do
      url = Imglab.url(Imglab::Source.new("assets"), "example.jpeg", :"trim" => "color", :"trim-color" => "orange")

      assert_equal url, "https://cdn.imglab.io/assets/example.jpeg?trim=color&trim-color=orange"
    end

    it "returns url with subdomains" do
      url =
        Imglab.url(
          Imglab::Source.new("assets", subdomains: true),
          "example.jpeg",
          width: 200,
          height: 300,
          format: "png"
        )

      assert_equal url, "https://assets.cdn.imglab.io/example.jpeg?width=200&height=300&format=png"
    end

    it "returns url with http" do
      url =
        Imglab.url(
          Imglab::Source.new("assets", https: false),
          "example.jpeg",
          width: 200,
          height: 300,
          format: "png"
        )

      assert_equal url, "http://cdn.imglab.io/assets/example.jpeg?width=200&height=300&format=png"
    end

    it "returns url with host" do
      url =
        Imglab.url(
          Imglab::Source.new("assets", host: "imglab.net"),
          "example.jpeg",
          width: 200,
          height: 300,
          format: "png"
        )

      assert_equal url, "https://imglab.net/assets/example.jpeg?width=200&height=300&format=png"
    end

    it "returns url with port" do
      url =
        Imglab.url(
          Imglab::Source.new("assets", port: 8080),
          "example.jpeg",
          width: 200,
          height: 300,
          format: "png"
        )

      assert_equal url, "https://cdn.imglab.io:8080/assets/example.jpeg?width=200&height=300&format=png"
    end

    it "returns url with subdomains, http, host and port" do
      url =
        Imglab.url(
          Imglab::Source.new("assets", subdomains: true, https: false, host: "imglab.net", port: 8080),
          "example.jpeg",
          width: 200,
          height: 300,
          format: "png"
        )

      assert_equal url, "http://assets.imglab.net:8080/example.jpeg?width=200&height=300&format=png"
    end

    it "returns url with path starting with slash" do
      url = Imglab.url(Imglab::Source.new("assets"), "/example.jpeg", width: 200, height: 300, format: "png")

      assert_equal url, "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&format=png"
    end

    it "returns url with path starting and ending with slash" do
      url = Imglab.url(Imglab::Source.new("assets"), "/example.jpeg/", width: 200, height: 300, format: "png")

      assert_equal url, "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&format=png"
    end

    it "returns url with subfolder path starting with slash" do
      url = Imglab.url(Imglab::Source.new("assets"), "/subfolder/example.jpeg", width: 200, height: 300, format: "png")

      assert_equal url, "https://cdn.imglab.io/assets/subfolder/example.jpeg?width=200&height=300&format=png"
    end

    it "returns url with subdfolder path starting and ending with slash" do
      url = Imglab.url(Imglab::Source.new("assets"), "/subfolder/example.jpeg/", width: 200, height: 300, format: "png")

      assert_equal url, "https://cdn.imglab.io/assets/subfolder/example.jpeg?width=200&height=300&format=png"
    end
  end

  describe ".url using secure source" do
    it "returns url without params" do
      url =
        Imglab.url(
          Imglab::Source.new("assets", secure_key: @secure_key, secure_salt: @secure_salt),
          "example.jpeg"
        )

      assert_equal url, "https://cdn.imglab.io/assets/example.jpeg?signature=aRgmnJ-7b2A0QLxXpR3cqrHVYmCfpRCOglL-nsp7SdQ"
    end

    it "returns url with params" do
      url =
        Imglab.url(
          Imglab::Source.new("assets", secure_key: @secure_key, secure_salt: @secure_salt),
          "example.jpeg",
          width: 200,
          height: 300,
          format: "png"
        )

      assert_equal url, "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&format=png&signature=VJ159IlBl_AlN59QWvyJov5SlQXlrZNpXgDJLJgzP8g"
    end

    it "returns url with params using string path" do
      url =
        Imglab.url(
          Imglab::Source.new("assets", secure_key: @secure_key, secure_salt: @secure_salt),
          "example.jpeg",
          width: 200,
          height: 300,
          watermark: "example.svg",
          format: "png"
        )

      assert_equal url, "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&watermark=example.svg&format=png&signature=xrwElVGVPyOrcTCNFnZiAa-tzkUp1ISrjnvEShSVsAg"
    end

    it "returns url with params using string path with inline params" do
      url =
        Imglab.url(
          Imglab::Source.new("assets", secure_key: @secure_key, secure_salt: @secure_salt),
          "example.jpeg",
          width: 200,
          height: 300,
          watermark: "example.svg?width=100&format=png",
          format: "png"
        )

      assert_equal url, "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&watermark=example.svg%3Fwidth%3D100%26format%3Dpng&format=png&signature=0yhBOktmTTVC-ANSxMuGK_LakyjCOlnGTSN3I13B188"
    end

    it "returns url with params using url method with source" do
      source = Imglab::Source.new("assets", secure_key: @secure_key, secure_salt: @secure_salt)

      url =
        Imglab.url(
          source,
          "example.jpeg",
          width: 200,
          height: 300,
          watermark: Imglab.url(source, "example.svg", width: 100, format: "png"),
          format: "png"
        )

      assert_equal url, "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&watermark=https%3A%2F%2Fcdn.imglab.io%2Fassets%2Fexample.svg%3Fwidth%3D100%26format%3Dpng%26signature%3DiKKUBWG4kZBv6CVxwaWGPpHd9LLTfuj9CBWamNYtWaI&format=png&signature=5__R2eDq59DYQnj64dyW3VlY-earzP6uyi624Q0Q4kU"
    end

    it "returns url with params using url method with source name" do
      source = Imglab::Source.new("assets", secure_key: @secure_key, secure_salt: @secure_salt)

      url =
        Imglab.url(
          source,
          "example.jpeg",
          width: 200,
          height: 300,
          watermark: Imglab.url(Imglab::Source.new("fixtures"), "example.svg", width: 100, format: "png"),
          format: "png"
        )

      assert_equal url, "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&watermark=https%3A%2F%2Fcdn.imglab.io%2Ffixtures%2Fexample.svg%3Fwidth%3D100%26format%3Dpng&format=png&signature=DiMzjeskcahfac0Xsy4QNj6qoU3dvKgOuFbHT7E4usU"
    end

    it "returns url with params using symbols with underscores" do
      url =
        Imglab.url(
          Imglab::Source.new("assets", secure_key: @secure_key, secure_salt: @secure_salt),
          "example.jpeg",
          trim: "color",
          trim_color: "orange"
        )

      assert_equal url, "https://cdn.imglab.io/assets/example.jpeg?trim=color&trim-color=orange&signature=cfYzBKvaWJhg_4ArtL5IafGYU6FEgRb_5ZADIgvviWw"
    end

    it "returns url with params using symbols with hyphens" do
      url =
        Imglab.url(
          Imglab::Source.new("assets", secure_key: @secure_key, secure_salt: @secure_salt),
          "example.jpeg",
          :"trim" => "color",
          :"trim-color" => "orange"
        )

      assert_equal url, "https://cdn.imglab.io/assets/example.jpeg?trim=color&trim-color=orange&signature=cfYzBKvaWJhg_4ArtL5IafGYU6FEgRb_5ZADIgvviWw"
    end

    it "returns url with subdomains" do
      url =
        Imglab.url(
          Imglab::Source.new("assets", secure_key: @secure_key, secure_salt: @secure_salt, subdomains: true),
          "example.jpeg",
          width: 200,
          height: 300,
          format: "png"
        )

      assert_equal url, "https://assets.cdn.imglab.io/example.jpeg?width=200&height=300&format=png&signature=VJ159IlBl_AlN59QWvyJov5SlQXlrZNpXgDJLJgzP8g"
    end

    it "returns url with http" do
      url =
        Imglab.url(
          Imglab::Source.new("assets", secure_key: @secure_key, secure_salt: @secure_salt, https: false),
          "example.jpeg",
          width: 200,
          height: 300,
          format: "png"
        )

      assert_equal url, "http://cdn.imglab.io/assets/example.jpeg?width=200&height=300&format=png&signature=VJ159IlBl_AlN59QWvyJov5SlQXlrZNpXgDJLJgzP8g"
    end

    it "returns url with host" do
      url =
        Imglab.url(
          Imglab::Source.new("assets", secure_key: @secure_key, secure_salt: @secure_salt, host: "imglab.net"),
          "example.jpeg",
          width: 200,
          height: 300,
          format: "png"
        )

      assert_equal url, "https://imglab.net/assets/example.jpeg?width=200&height=300&format=png&signature=VJ159IlBl_AlN59QWvyJov5SlQXlrZNpXgDJLJgzP8g"
    end

    it "returns url with port" do
      url =
        Imglab.url(
          Imglab::Source.new("assets", secure_key: @secure_key, secure_salt: @secure_salt, port: 8080),
          "example.jpeg",
          width: 200,
          height: 300,
          format: "png"
        )

      assert_equal url, "https://cdn.imglab.io:8080/assets/example.jpeg?width=200&height=300&format=png&signature=VJ159IlBl_AlN59QWvyJov5SlQXlrZNpXgDJLJgzP8g"
    end

    it "returns url with subdomains, http, host and port" do
      source =
        Imglab::Source.new(
          "assets",
          secure_key: @secure_key,
          secure_salt: @secure_salt,
          subdomains: true,
          https: false,
          host: "imglab.net",
          port: 8080
        )

      url = Imglab.url(source, "example.jpeg", width: 200, height: 300, format: "png")

      assert_equal url, "http://assets.imglab.net:8080/example.jpeg?width=200&height=300&format=png&signature=VJ159IlBl_AlN59QWvyJov5SlQXlrZNpXgDJLJgzP8g"
    end

    it "returns url with path starting with slash" do
      url =
        Imglab.url(
          Imglab::Source.new("assets", secure_key: @secure_key, secure_salt: @secure_salt),
          "/example.jpeg",
          width: 200,
          height: 300,
          format: "png"
        )

      assert_equal url, "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&format=png&signature=VJ159IlBl_AlN59QWvyJov5SlQXlrZNpXgDJLJgzP8g"
    end

    it "returns url with path starting and ending with slash" do
      url =
        Imglab.url(
          Imglab::Source.new("assets", secure_key: @secure_key, secure_salt: @secure_salt),
          "/example.jpeg/",
          width: 200,
          height: 300,
          format: "png"
        )

      assert_equal url, "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&format=png&signature=VJ159IlBl_AlN59QWvyJov5SlQXlrZNpXgDJLJgzP8g"
    end

    it "returns url with subfolder path starting with slash" do
      url =
        Imglab.url(
          Imglab::Source.new("assets", secure_key: @secure_key, secure_salt: @secure_salt),
          "/subfolder/example.jpeg",
          width: 200,
          height: 300,
          format: "png"
        )

      assert_equal url, "https://cdn.imglab.io/assets/subfolder/example.jpeg?width=200&height=300&format=png&signature=3jydAIXhF8Nn_LXKhog2flf7FsACzISi_sXCKmASkOs"
    end

    it "returns url with subdfolder path starting and ending with slash" do
      url =
        Imglab.url(
          Imglab::Source.new("assets", secure_key: @secure_key, secure_salt: @secure_salt),
          "/subfolder/example.jpeg/",
          width: 200,
          height: 300,
          format: "png"
        )

      assert_equal url, "https://cdn.imglab.io/assets/subfolder/example.jpeg?width=200&height=300&format=png&signature=3jydAIXhF8Nn_LXKhog2flf7FsACzISi_sXCKmASkOs"
    end
  end

  describe ".url using an invalid source or source name argument" do
    it "raises an argument error when the source or source name is invalid" do
      assert_raises(ArgumentError) { Imglab.url(nil, "example.jpeg") }
      assert_raises(ArgumentError) { Imglab.url({}, "example.jpeg") }
      assert_raises(ArgumentError) { Imglab.url(:invalid, "example.jpeg") }
      assert_raises(ArgumentError) { Imglab.url(10, "example.jpeg") }
    end
  end
end
