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

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg"
    end

    it "returns url with params" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&format=png"
    end

    it "returns url with Base64 params" do
      url = Imglab.url("assets", "example.jpeg", width64: 200, height64: 300, format64: "png")

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width64=MjAw&height64=MzAw&format64=cG5n"
    end

    it "returns url with Base64 aliased params" do
      url = Imglab.url("assets", "example.jpeg", w64: 200, h64: 300, fm64: "png")

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?w64=MjAw&h64=MzAw&fm64=cG5n"
    end

    it "returns url with nil params" do
      url = Imglab.url("assets", "example.jpeg", width: 200, download: nil)

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&download="
    end

    it "returns url with Base64 nil params" do
      url = Imglab.url("assets", "example.jpeg", width: 200, download64: nil)

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&download64="
    end

    it "returns url with params using string path" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, watermark: "example.svg", format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&watermark=example.svg&format=png"
    end

    it "returns url with Base64 params using string path" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, watermark64: "example.svg", format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&watermark64=ZXhhbXBsZS5zdmc&format=png"
    end

    it "returns url with params using string path with inline params" do
      url =
        Imglab.url("assets", "example.jpeg",
          width: 200,
          height: 300,
          watermark: "example.svg?width=100&format=png",
          format: "png"
        )

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&watermark=example.svg%3Fwidth%3D100%26format%3Dpng&format=png"
    end

    it "returns url with Base64 params using string path with inline params" do
      url =
        Imglab.url("assets", "example.jpeg",
          width: 200,
          height: 300,
          watermark64: "example.svg?width=100&format=png",
          format: "png"
        )

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&watermark64=ZXhhbXBsZS5zdmc_d2lkdGg9MTAwJmZvcm1hdD1wbmc&format=png"
    end

    it "returns url with params using rgb color" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, background_color: color(255, 128, 122))

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&background-color=255%2C128%2C122"
    end

    it "returns url with Base64 params using rgb color" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, background_color64: color(255, 128, 122))

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&background-color64=MjU1LDEyOCwxMjI"
    end

    it "returns url with params using rgba color" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, background_color: color(255, 128, 122, 128))

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&background-color=255%2C128%2C122%2C128"
    end

    it "returns url with Base64 params using rgba color" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, background_color64: color(255, 128, 122, 128))

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&background-color64=MjU1LDEyOCwxMjIsMTI4"
    end

    it "returns url with params using named color" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, background_color: color("blue"))

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&background-color=blue"
    end

    it "returns url with Base64 params using named color" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, background_color64: color("blue"))

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&background-color64=Ymx1ZQ"
    end

    it "returns url with params using horizontal and vertical position" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, mode: "crop", crop: position("left", "bottom"))

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&mode=crop&crop=left%2Cbottom"
    end

    it "returns url with Base64 params using horizontal and vertical position" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, mode: "crop", crop64: position("left", "bottom"))

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&mode=crop&crop64=bGVmdCxib3R0b20"
    end

    it "returns url with params using vertical and horizontal position" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, mode: "crop", crop: position("bottom", "left"))

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&mode=crop&crop=bottom%2Cleft"
    end

    it "returns url with Base64 params using vertical and horizontal position" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, mode: "crop", crop64: position("bottom", "left"))

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&mode=crop&crop64=Ym90dG9tLGxlZnQ"
    end

    it "returns url with params using position" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, mode: "crop", crop: position("left"))

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&mode=crop&crop=left"
    end

    it "returns url with Base64 params using position" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, mode: "crop", crop64: position("left"))

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&mode=crop&crop64=bGVmdA"
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

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&watermark=https%3A%2F%2Fassets.imglab-cdn.net%2Fexample.svg%3Fwidth%3D100%26format%3Dpng&format=png"
    end

    it "returns url with Base64 params using url method with source" do
      source = Imglab::Source.new("assets")

      url =
        Imglab.url(
          "assets",
          "example.jpeg",
          width: 200,
          height: 300,
          watermark64: Imglab.url(source, "example.svg", width: 100, format: "png"),
          format: "png"
        )

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&watermark64=aHR0cHM6Ly9hc3NldHMuaW1nbGFiLWNkbi5uZXQvZXhhbXBsZS5zdmc_d2lkdGg9MTAwJmZvcm1hdD1wbmc&format=png"
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

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&watermark=https%3A%2F%2Fassets.imglab-cdn.net%2Fexample.svg%3Fwidth%3D100%26format%3Dpng&format=png"
    end

    it "returns url with Base64 params using url method with source name" do
      url =
        Imglab.url(
          "assets",
          "example.jpeg",
          width: 200,
          height: 300,
          watermark64: Imglab.url("assets", "example.svg", width: 100, format: "png"),
          format: "png"
        )

        assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&watermark64=aHR0cHM6Ly9hc3NldHMuaW1nbGFiLWNkbi5uZXQvZXhhbXBsZS5zdmc_d2lkdGg9MTAwJmZvcm1hdD1wbmc&format=png"
    end

    it "returns url with params using symbols with underscores" do
      url = Imglab.url("assets", "example.jpeg", trim: "color", trim_color: "orange")

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?trim=color&trim-color=orange"
    end

    it "returns url with Base64 params using symbols with underscores" do
      url = Imglab.url("assets", "example.jpeg", trim: "color", trim_color64: "orange")

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?trim=color&trim-color64=b3Jhbmdl"
    end

    it "returns url with params using symbols with hyphens" do
      url = Imglab.url("assets", "example.jpeg", :"trim" => "color", :"trim-color" => "orange")

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?trim=color&trim-color=orange"
    end

    it "returns url with Base64 params using symbols with hyphens" do
      url = Imglab.url("assets", "example.jpeg", :"trim" => "color", :"trim-color64" => "orange")

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?trim=color&trim-color64=b3Jhbmdl"
    end

    it "returns url with expires param using a Time instance" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, expires: Time.at(1464096368))

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&expires=1464096368"
    end

    it "returns url with Base64 param using a Time instance" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, expires64: Time.at(1464096368))

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&expires64=MTQ2NDA5NjM2OA"
    end

    it "returns url with path starting with slash" do
      url = Imglab.url("assets", "/example.jpeg", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&format=png"
    end

    it "returns url with path starting with slash using reserved characters" do
      url = Imglab.url("assets", "/example image%2C01%2C02.jpeg", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/example%20image%252C01%252C02.jpeg?width=200&height=300&format=png"
    end

    it "returns url with path starting and ending with slash" do
      url = Imglab.url("assets", "/example.jpeg/", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&format=png"
    end

    it "returns url with path starting and ending with slash using reserved characters" do
      url = Imglab.url("assets", "/example image%2C01%2C02.jpeg/", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/example%20image%252C01%252C02.jpeg?width=200&height=300&format=png"
    end

    it "returns url with subfolder path starting with slash" do
      url = Imglab.url("assets", "/subfolder/example.jpeg", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/subfolder/example.jpeg?width=200&height=300&format=png"
    end

    it "returns url with subfolder path starting with slash using reserved characters" do
      url = Imglab.url("assets", "/subfolder images/example image%2C01%2C02.jpeg", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/subfolder%20images/example%20image%252C01%252C02.jpeg?width=200&height=300&format=png"
    end

    it "returns url with subfolder path starting and ending with slash" do
      url = Imglab.url("assets", "/subfolder/example.jpeg/", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/subfolder/example.jpeg?width=200&height=300&format=png"
    end

    it "returns url with subfolder path starting and ending with slash using reserved characters" do
      url = Imglab.url("assets", "/subfolder images/example image%2C01%2C02.jpeg/", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/subfolder%20images/example%20image%252C01%252C02.jpeg?width=200&height=300&format=png"
    end

    it "returns url with path using a http url" do
      url = Imglab.url("assets", "http://assets.com/subfolder/example.jpeg", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/http%3A%2F%2Fassets.com%2Fsubfolder%2Fexample.jpeg?width=200&height=300&format=png"
    end

    it "returns url with path using a http url with reserved characters" do
      url = Imglab.url("assets", "http://assets.com/subfolder/example%2C01%2C02.jpeg", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/http%3A%2F%2Fassets.com%2Fsubfolder%2Fexample%252C01%252C02.jpeg?width=200&height=300&format=png"
    end

    it "returns url with path using a https url" do
      url = Imglab.url("assets", "https://assets.com/subfolder/example.jpeg", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/https%3A%2F%2Fassets.com%2Fsubfolder%2Fexample.jpeg?width=200&height=300&format=png"
    end

    it "returns url with path using a https url with reserved characters" do
      url = Imglab.url("assets", "https://assets.com/subfolder/example%2C01%2C02.jpeg", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/https%3A%2F%2Fassets.com%2Fsubfolder%2Fexample%252C01%252C02.jpeg?width=200&height=300&format=png"
    end
  end

  describe ".url using source" do
    before do
      @source = Imglab::Source.new("assets")
    end

    it "returns url without params" do
      url = Imglab.url(@source, "example.jpeg")

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg"
    end

    it "returns url with params" do
      url = Imglab.url(@source, "example.jpeg", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&format=png"
    end

    it "returns url with Base64 params" do
      url = Imglab.url(@source, "example.jpeg", width64: 200, height64: 300, format64: "png")

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width64=MjAw&height64=MzAw&format64=cG5n"
    end

    it "returns url with Base64 aliased params" do
      url = Imglab.url(@source, "example.jpeg", w64: 200, h64: 300, fm64: "png")

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?w64=MjAw&h64=MzAw&fm64=cG5n"
    end

    it "returns url with nil params" do
      url = Imglab.url(@source, "example.jpeg", width: 200, download: nil)

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&download="
    end

    it "returns url with Base64 nil params" do
      url = Imglab.url(@source, "example.jpeg", width: 200, download64: nil)

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&download64="
    end

    it "returns url with params using string path" do
      url = Imglab.url(@source, "example.jpeg", width: 200, height: 300, watermark: "example.svg", format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&watermark=example.svg&format=png"
    end

    it "returns url with Base64 params using string path" do
      url = Imglab.url(@source, "example.jpeg", width: 200, height: 300, watermark64: "example.svg", format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&watermark64=ZXhhbXBsZS5zdmc&format=png"
    end

    it "returns url with params using string path with inline params" do
      url =
        Imglab.url(
          @source,
          "example.jpeg",
          width: 200,
          height: 300,
          watermark: "example.svg?width=100&format=png",
          format: "png"
        )

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&watermark=example.svg%3Fwidth%3D100%26format%3Dpng&format=png"
    end

    it "returns url with Base64 params using string path with inline params" do
      url =
        Imglab.url(
          @source,
          "example.jpeg",
          width: 200,
          height: 300,
          watermark64: "example.svg?width=100&format=png",
          format: "png"
        )

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&watermark64=ZXhhbXBsZS5zdmc_d2lkdGg9MTAwJmZvcm1hdD1wbmc&format=png"
    end

    it "returns url with params using url with source" do
      source = @source

      url =
        Imglab.url(
          source,
          "example.jpeg",
          width: 200,
          height: 300,
          watermark: Imglab.url(source, "example.svg", width: 100, format: "png"),
          format: "png"
        )

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&watermark=https%3A%2F%2Fassets.imglab-cdn.net%2Fexample.svg%3Fwidth%3D100%26format%3Dpng&format=png"
    end

    it "returns url with Base64 params using url with source" do
      source = @source

      url =
        Imglab.url(
          source,
          "example.jpeg",
          width: 200,
          height: 300,
          watermark64: Imglab.url(source, "example.svg", width: 100, format: "png"),
          format: "png"
        )

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&watermark64=aHR0cHM6Ly9hc3NldHMuaW1nbGFiLWNkbi5uZXQvZXhhbXBsZS5zdmc_d2lkdGg9MTAwJmZvcm1hdD1wbmc&format=png"
    end

    it "returns url with params using url method with source name" do
      source = @source

      url =
        Imglab.url(
          source,
          "example.jpeg",
          width: 200,
          height: 300,
          watermark: Imglab.url("assets", "example.svg", width: 100, format: "png"),
          format: "png"
        )

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&watermark=https%3A%2F%2Fassets.imglab-cdn.net%2Fexample.svg%3Fwidth%3D100%26format%3Dpng&format=png"
    end

    it "returns url with Base64 params using url method with source name" do
      source = @source

      url =
        Imglab.url(
          source,
          "example.jpeg",
          width: 200,
          height: 300,
          watermark64: Imglab.url("assets", "example.svg", width: 100, format: "png"),
          format: "png"
        )

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&watermark64=aHR0cHM6Ly9hc3NldHMuaW1nbGFiLWNkbi5uZXQvZXhhbXBsZS5zdmc_d2lkdGg9MTAwJmZvcm1hdD1wbmc&format=png"
    end

    it "returns url with params using symbols with underscores" do
      url = Imglab.url(@source, "example.jpeg", trim: "color", trim_color: "orange")

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?trim=color&trim-color=orange"
    end

    it "returns url with Base64 params using symbols with underscores" do
      url = Imglab.url(@source, "example.jpeg", trim: "color", trim_color64: "orange")

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?trim=color&trim-color64=b3Jhbmdl"
    end

    it "returns url with params using atoms with hyphens" do
      url = Imglab.url(@source, "example.jpeg", :"trim" => "color", :"trim-color" => "orange")

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?trim=color&trim-color=orange"
    end

    it "returns url with Base64 params using atoms with hyphens" do
      url = Imglab.url(@source, "example.jpeg", :"trim" => "color", :"trim-color64" => "orange")

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?trim=color&trim-color64=b3Jhbmdl"
    end

    it "returns url with expires param using a Time instance" do
      url = Imglab.url(@source, "example.jpeg", width: 200, height: 300, expires: Time.at(1464096368))

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&expires=1464096368"
    end

    it "returns url with Base64 param using a Time instance" do
      url = Imglab.url(@source, "example.jpeg", width: 200, height: 300, expires64: Time.at(1464096368))

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&expires64=MTQ2NDA5NjM2OA"
    end

    it "returns url with disabled subdomains" do
      url =
        Imglab.url(
          Imglab::Source.new("assets", subdomains: false),
          "example.jpeg",
          width: 200,
          height: 300,
          format: "png"
        )

      assert_equal url, "https://imglab-cdn.net/assets/example.jpeg?width=200&height=300&format=png"
    end

    it "returns url with disabled https" do
      url =
        Imglab.url(
          Imglab::Source.new("assets", https: false),
          "example.jpeg",
          width: 200,
          height: 300,
          format: "png"
        )

      assert_equal url, "http://assets.imglab-cdn.net/example.jpeg?width=200&height=300&format=png"
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

      assert_equal url, "https://assets.imglab.net/example.jpeg?width=200&height=300&format=png"
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

      assert_equal url, "https://assets.imglab-cdn.net:8080/example.jpeg?width=200&height=300&format=png"
    end

    it "returns url with disabled subdomains, disabled https, host and port" do
      url =
        Imglab.url(
          Imglab::Source.new("assets", subdomains: false, https: false, host: "imglab.net", port: 8080),
          "example.jpeg",
          width: 200,
          height: 300,
          format: "png"
        )

      assert_equal url, "http://imglab.net:8080/assets/example.jpeg?width=200&height=300&format=png"
    end

    it "returns url with path starting with slash" do
      url = Imglab.url(@source, "/example.jpeg", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&format=png"
    end

    it "returns url with path starting with slash using reserved characters" do
      url = Imglab.url(@source, "/example image%2C01%2C02.jpeg", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/example%20image%252C01%252C02.jpeg?width=200&height=300&format=png"
    end

    it "returns url with path starting and ending with slash" do
      url = Imglab.url(@source, "/example.jpeg/", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&format=png"
    end

    it "returns url with path starting and ending with slash using reserved characters" do
      url = Imglab.url(@source, "/example image%2C01%2C02.jpeg/", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/example%20image%252C01%252C02.jpeg?width=200&height=300&format=png"
    end

    it "returns url with subfolder path starting with slash" do
      url = Imglab.url(@source, "/subfolder/example.jpeg", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/subfolder/example.jpeg?width=200&height=300&format=png"
    end

    it "returns url with subfolder path starting with slash using reserved characters" do
      url = Imglab.url(@source, "/subfolder images/example image%2C01%2C02.jpeg", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/subfolder%20images/example%20image%252C01%252C02.jpeg?width=200&height=300&format=png"
    end

    it "returns url with subfolder path starting and ending with slash" do
      url = Imglab.url(@source, "/subfolder/example.jpeg/", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/subfolder/example.jpeg?width=200&height=300&format=png"
    end

    it "returns url with subfolder path starting and ending with slash using reserved characters" do
      url = Imglab.url(@source, "/subfolder images/example image%2C01%2C02.jpeg/", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/subfolder%20images/example%20image%252C01%252C02.jpeg?width=200&height=300&format=png"
    end

    it "returns url with path using a http url" do
      url = Imglab.url(@source, "http://assets.com/subfolder/example.jpeg", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/http%3A%2F%2Fassets.com%2Fsubfolder%2Fexample.jpeg?width=200&height=300&format=png"
    end

    it "returns url with path using a http url with reserved characters" do
      url = Imglab.url(@source, "http://assets.com/subfolder/example%2C01%2C02.jpeg", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/http%3A%2F%2Fassets.com%2Fsubfolder%2Fexample%252C01%252C02.jpeg?width=200&height=300&format=png"
    end

    it "returns url with path using a https url" do
      url = Imglab.url(@source, "https://assets.com/subfolder/example.jpeg", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/https%3A%2F%2Fassets.com%2Fsubfolder%2Fexample.jpeg?width=200&height=300&format=png"
    end

    it "returns url with path using a https url with reserved characters" do
      url = Imglab.url(@source, "https://assets.com/subfolder/example%2C01%2C02.jpeg", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/https%3A%2F%2Fassets.com%2Fsubfolder%2Fexample%252C01%252C02.jpeg?width=200&height=300&format=png"
    end
  end

  describe ".url using secure source" do
    before do
      @source = Imglab::Source.new("assets", secure_key: @secure_key, secure_salt: @secure_salt)
    end

    it "returns url without params" do
      url = Imglab.url(@source, "example.jpeg")

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?signature=aRgmnJ-7b2A0QLxXpR3cqrHVYmCfpRCOglL-nsp7SdQ"
    end

    it "returns url with params" do
      url = Imglab.url(@source, "example.jpeg", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&format=png&signature=VJ159IlBl_AlN59QWvyJov5SlQXlrZNpXgDJLJgzP8g"
    end

    it "returns url with Base64 params" do
      url = Imglab.url(@source, "example.jpeg", width64: 200, height64: 300, format64: "png")

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width64=MjAw&height64=MzAw&format64=cG5n&signature=sXAQfaUDjzkYPE_gm-_5U_9hAMBTX_7QSNoTSiJp8xE"
    end

    it "returns url with Base64 aliased params" do
      url = Imglab.url(@source, "example.jpeg", w64: 200, h64: 300, fm64: "png")

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?w64=MjAw&h64=MzAw&fm64=cG5n&signature=xb7xWZDEv2B_Erm9yfHuEMNzCEcvjRYKapBM-faQm4w"
    end

    it "returns url with nil params" do
      url = Imglab.url(@source, "example.jpeg", width: 200, download: nil)

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&download=&signature=ljL9HNRaxVrk7jfQaf6FPYFZn4RJzQPCW-aVNJoIQI8"
    end

    it "returns url with Base64 nil params" do
      url = Imglab.url(@source, "example.jpeg", width: 200, download64: nil)

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&download64=&signature=B64OUotc1eKCSvgD_FYUXlC-WKFGE8O04g4Y9ZsQzzI"
    end

    it "returns url with params using string path" do
      url = Imglab.url(@source, "example.jpeg", width: 200, height: 300, watermark: "example.svg", format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&watermark=example.svg&format=png&signature=xrwElVGVPyOrcTCNFnZiAa-tzkUp1ISrjnvEShSVsAg"
    end

    it "returns url with Base64 params using string path" do
      url = Imglab.url(@source, "example.jpeg", width: 200, height: 300, watermark64: "example.svg", format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&watermark64=ZXhhbXBsZS5zdmc&format=png&signature=fPnOY_qB6Aq6NuzBusnj1n-l1T9SvQ4lqRWTtiFgMWc"
    end

    it "returns url with params using string path with inline params" do
      url =
        Imglab.url(
          @source,
          "example.jpeg",
          width: 200,
          height: 300,
          watermark: "example.svg?width=100&format=png",
          format: "png"
        )

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&watermark=example.svg%3Fwidth%3D100%26format%3Dpng&format=png&signature=0yhBOktmTTVC-ANSxMuGK_LakyjCOlnGTSN3I13B188"
    end

    it "returns url with Base64 params using string path with inline params" do
      url =
        Imglab.url(
          @source,
          "example.jpeg",
          width: 200,
          height: 300,
          watermark64: "example.svg?width=100&format=png",
          format: "png"
        )

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&watermark64=ZXhhbXBsZS5zdmc_d2lkdGg9MTAwJmZvcm1hdD1wbmc&format=png&signature=Ko8UMfsuZUZvC0SYLRAhhv5W5YIGMRo8NFDw-iEjOUE"
    end

    it "returns url with params using url method with source" do
      url =
        Imglab.url(
          @source,
          "example.jpeg",
          width: 200,
          height: 300,
          watermark: Imglab.url(@source, "example.svg", width: 100, format: "png"),
          format: "png"
        )

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&watermark=https%3A%2F%2Fassets.imglab-cdn.net%2Fexample.svg%3Fwidth%3D100%26format%3Dpng%26signature%3DiKKUBWG4kZBv6CVxwaWGPpHd9LLTfuj9CBWamNYtWaI&format=png&signature=ZMT8l8i9hKs4aYiIUXpGcMSzOGHS8xjUlQeTrvE8ESA"
    end

    it "returns url with params using url method with source name" do
      url =
        Imglab.url(
          @source,
          "example.jpeg",
          width: 200,
          height: 300,
          watermark: Imglab.url(Imglab::Source.new("fixtures"), "example.svg", width: 100, format: "png"),
          format: "png"
        )

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&watermark=https%3A%2F%2Ffixtures.imglab-cdn.net%2Fexample.svg%3Fwidth%3D100%26format%3Dpng&format=png&signature=6BowGGEXe9wUmGa4xkhoscfPkqrLGumkIglhPQEkNuo"
    end

    it "returns url with Base64 params using url method with source name" do
      url =
        Imglab.url(
          @source,
          "example.jpeg",
          width: 200,
          height: 300,
          watermark64: Imglab.url(Imglab::Source.new("fixtures"), "example.svg", width: 100, format: "png"),
          format: "png"
        )

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&watermark64=aHR0cHM6Ly9maXh0dXJlcy5pbWdsYWItY2RuLm5ldC9leGFtcGxlLnN2Zz93aWR0aD0xMDAmZm9ybWF0PXBuZw&format=png&signature=v_nGkN_6nrFku0zIYUKLavVoKfQ6_mIFWxAE-_FceuU"
    end

    it "returns url with params using symbols with underscores" do
      url = Imglab.url(@source, "example.jpeg", trim: "color", trim_color: "orange")

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?trim=color&trim-color=orange&signature=cfYzBKvaWJhg_4ArtL5IafGYU6FEgRb_5ZADIgvviWw"
    end

    it "returns url with Base64 params using symbols with underscores" do
      url = Imglab.url(@source, "example.jpeg", trim: "color", trim_color64: "orange")

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?trim=color&trim-color64=b3Jhbmdl&signature=e8YY9LWXog4KewJ26Onc0Tif_4VQYDC7tz2XExBwYxw"
    end

    it "returns url with params using symbols with hyphens" do
      url = Imglab.url(@source, "example.jpeg", :"trim" => "color", :"trim-color" => "orange")

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?trim=color&trim-color=orange&signature=cfYzBKvaWJhg_4ArtL5IafGYU6FEgRb_5ZADIgvviWw"
    end

    it "returns url with Base64 params using symbols with hyphens" do
      url = Imglab.url(@source, "example.jpeg", :"trim" => "color", :"trim-color64" => "orange")

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?trim=color&trim-color64=b3Jhbmdl&signature=e8YY9LWXog4KewJ26Onc0Tif_4VQYDC7tz2XExBwYxw"
    end

    it "returns url with expires param using a Time instance" do
      url = Imglab.url(@source, "example.jpeg", width: 200, height: 300, expires: Time.at(1464096368))

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&expires=1464096368&signature=DpkRMiecDlOaQAQM5IQ8Cd4ek8nGvfPxV6XmCN0GbAU"
    end

    it "returns url with Base64 param using a Time instance" do
      url = Imglab.url(@source, "example.jpeg", width: 200, height: 300, expires64: Time.at(1464096368))

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&expires64=MTQ2NDA5NjM2OA&signature=31sVYqPklyj8oC3lq9I4OQALK9AA7TkGHmTzbE50JLc"
    end

    it "returns url with disabled subdomains" do
      url =
        Imglab.url(
          Imglab::Source.new("assets", secure_key: @secure_key, secure_salt: @secure_salt, subdomains: false),
          "example.jpeg",
          width: 200,
          height: 300,
          format: "png"
        )

      assert_equal url, "https://imglab-cdn.net/assets/example.jpeg?width=200&height=300&format=png&signature=VJ159IlBl_AlN59QWvyJov5SlQXlrZNpXgDJLJgzP8g"
    end

    it "returns url with disabled https" do
      url =
        Imglab.url(
          Imglab::Source.new("assets", secure_key: @secure_key, secure_salt: @secure_salt, https: false),
          "example.jpeg",
          width: 200,
          height: 300,
          format: "png"
        )

      assert_equal url, "http://assets.imglab-cdn.net/example.jpeg?width=200&height=300&format=png&signature=VJ159IlBl_AlN59QWvyJov5SlQXlrZNpXgDJLJgzP8g"
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

      assert_equal url, "https://assets.imglab.net/example.jpeg?width=200&height=300&format=png&signature=VJ159IlBl_AlN59QWvyJov5SlQXlrZNpXgDJLJgzP8g"
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

      assert_equal url, "https://assets.imglab-cdn.net:8080/example.jpeg?width=200&height=300&format=png&signature=VJ159IlBl_AlN59QWvyJov5SlQXlrZNpXgDJLJgzP8g"
    end

    it "returns url with disabled subdomains, disabled https, host and port" do
      source =
        Imglab::Source.new(
          "assets",
          secure_key: @secure_key,
          secure_salt: @secure_salt,
          subdomains: false,
          https: false,
          host: "imglab.net",
          port: 8080
        )

      url = Imglab.url(source, "example.jpeg", width: 200, height: 300, format: "png")

      assert_equal url, "http://imglab.net:8080/assets/example.jpeg?width=200&height=300&format=png&signature=VJ159IlBl_AlN59QWvyJov5SlQXlrZNpXgDJLJgzP8g"
    end

    it "returns url with path starting with slash" do
      url = Imglab.url(@source, "/example.jpeg", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&format=png&signature=VJ159IlBl_AlN59QWvyJov5SlQXlrZNpXgDJLJgzP8g"
    end

    it "returns url with path starting with slash using reserved characters" do
      url = Imglab.url(@source, "/example image%2C01%2C02.jpeg", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/example%20image%252C01%252C02.jpeg?width=200&height=300&format=png&signature=yZcUhTCB9VB3qzjyIJCCX_pfJ76Gb6kHe7KwusAPl-w"
    end

    it "returns url with path starting and ending with slash" do
      url = Imglab.url(@source, "/example.jpeg/", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&format=png&signature=VJ159IlBl_AlN59QWvyJov5SlQXlrZNpXgDJLJgzP8g"
    end

    it "returns url with path starting and ending with slash using reserved characters" do
      url = Imglab.url(@source, "/example image%2C01%2C02.jpeg/", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/example%20image%252C01%252C02.jpeg?width=200&height=300&format=png&signature=yZcUhTCB9VB3qzjyIJCCX_pfJ76Gb6kHe7KwusAPl-w"
    end

    it "returns url with subfolder path starting with slash" do
      url = Imglab.url(@source, "/subfolder/example.jpeg", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/subfolder/example.jpeg?width=200&height=300&format=png&signature=3jydAIXhF8Nn_LXKhog2flf7FsACzISi_sXCKmASkOs"
    end

    it "returns url with subfolder path starting with slash using reserved characters" do
      url = Imglab.url(@source, "/subfolder images/example image%2C01%2C02.jpeg", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/subfolder%20images/example%20image%252C01%252C02.jpeg?width=200&height=300&format=png&signature=2oAmYelI7UEnvqSSPCfUA25TmS7na1FRVTaxfe5ADyY"
    end

    it "returns url with subfolder path starting and ending with slash" do
      url = Imglab.url(@source, "/subfolder/example.jpeg/", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/subfolder/example.jpeg?width=200&height=300&format=png&signature=3jydAIXhF8Nn_LXKhog2flf7FsACzISi_sXCKmASkOs"
    end

    it "returns url with subfolder path starting and ending with slash using reserved characters" do
      url = Imglab.url(@source, "/subfolder images/example image%2C01%2C02.jpeg/", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/subfolder%20images/example%20image%252C01%252C02.jpeg?width=200&height=300&format=png&signature=2oAmYelI7UEnvqSSPCfUA25TmS7na1FRVTaxfe5ADyY"
    end

    it "returns url with path using a http url" do
      url = Imglab.url(@source, "http://assets.com/subfolder/example.jpeg", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/http%3A%2F%2Fassets.com%2Fsubfolder%2Fexample.jpeg?width=200&height=300&format=png&signature=MuzfKbHDJY6lzeFQGRcsCS8DzxgL4nCpIowOMFLR1kA"
    end

    it "returns url with path using a http url with reserved characters" do
      url = Imglab.url(@source, "http://assets.com/subfolder/example%2C01%2C02.jpeg", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/http%3A%2F%2Fassets.com%2Fsubfolder%2Fexample%252C01%252C02.jpeg?width=200&height=300&format=png&signature=78e-ysfcy3d0e0rj70QJQ3wpuwI_hAl9ZYxIUVRw62I"
    end

    it "returns url with path using a https url" do
      url = Imglab.url(@source, "https://assets.com/subfolder/example.jpeg", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/https%3A%2F%2Fassets.com%2Fsubfolder%2Fexample.jpeg?width=200&height=300&format=png&signature=7Dp8Q01u_5YmpmH-j_y4P5vzOn_9EGvh77B3fi2Ke-s"
    end

    it "returns url with path using a https url with reserved characters" do
      url = Imglab.url(@source, "https://assets.com/subfolder/example%2C01%2C02.jpeg", width: 200, height: 300, format: "png")

      assert_equal url, "https://assets.imglab-cdn.net/https%3A%2F%2Fassets.com%2Fsubfolder%2Fexample%252C01%252C02.jpeg?width=200&height=300&format=png&signature=-zvh2hWXP8bHkoJVh8AdJFe9Kqdd1HpP1c2UmuQcYFQ"
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
