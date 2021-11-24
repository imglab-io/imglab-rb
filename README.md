# imglab

`imglab` is the official Ruby library to integrate with imglab services.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "imglab", "~> 0.1.0"
```

And then execute:

```sh
$ bundle install
```

Or install it yourself as:

```sh
$ gem install imglab
```

## Ruby compatibility

`imglab` has been successfully tested on the following Ruby versions: `3.0`, `2.7`, `2.6`, `2.5`, `2.4`, `2.3`, `2.2`, `2.1` and `2.0`.

## Generating URLs

You can use `Imglab.url` function to generate imglab compatible URLs for your application.

The easiest way to generate a URL is to specify the `source_name`, `path` and required `parameters`:

```ruby
Imglab.url("assets", "image.jpeg", width: 500, height: 600)
"https://cdn.imglab.io/assets/image.jpeg?width=500&height=600"

Imglab.url("avatars", "user-01.jpeg", width: 300, height: 300, mode: :crop, crop: :face, format: :webp)
"https://cdn.imglab.io/avatars/user-01.jpeg?width=300&height=300&mode=crop&crop=face&format=webp"
```

If some specific settings are required for the source you can use an instance of `Imglab::Source` class instead of a `string` source name:

```ruby
Imglab.url(Imglab::Source.new("assets"), "image.jpeg", width: 500, height: 600)
"https://cdn.imglab.io/assets/image.jpeg?width=500&height=600"
```

### Using secure image sources

For sources that require signed URLs you can specify `secure_key` and `secure_salt` attributes for the source:

```ruby
source = Imglab::Source.new(secure_key: "assets-secure-key", secure_salt: "assets-secure-salt")

Imglab.url(source, "image.jpeg", width: 500, height: 600)
"https://cdn.imglab.io/assets/image.jpeg?width=500&height=600&signature=generated-signature"
```

`signature` query parameter will be automatically generated and attached to the returned URL.

> Note: `secure_key` and `secure_salt` attributes are secrets that should not be added to a code repository. Please use environment vars or other secure method to use them in your application.

### Using HTTP instead of HTTPS

In the case that HTTP schema is required instead of HTTPS you can set `https` attribute to `false` when creating the source:

```ruby
Imglab.url(Imglab::Source.new("assets", https: false), "image.jpeg", width: 500, height: 600)
"http://cdn.imglab.io/assets/image.jpeg?width=500&height=600"
```

> Note: HTTPS is the default and recommended way to generate URLs with imglab.

### Specifying parameters

Any parameter from the imglab API can be used to generate URLs with `Imglab.url` method. For parameters that required dashes characters like `trim-color` you can use regular underscore Ruby symbols like `:trim_color` those will be normalized in the URL generation to it's correct form:

```ruby
Imglab.url("assets", "image.jpeg", trim: "color", trim_color: "black")
"https://cdn.imglab.io/assets/image.jpeg?trim=color&trim-color=black"
```

It is possible to use strings too:

```ruby
Imglab.url("assets", "image.jpeg", "trim" => "color", "trim-color" => "black")
"https://cdn.imglab.io/assets/image.jpeg?trim=color&trim-color=black"
```

And quoted symbols for Ruby version >= 2.2:

```ruby
Imglab.url("assets", "image.jpeg", trim: "color", "trim-color": "black")
"https://cdn.imglab.io/assets/image.jpeg?trim=color&trim-color=black"
```

### Specifying color parameters

Some imglab parameters can receive a color as value. It is possible to specify these color values as strings:

```ruby
# Specifying a RGB color as string
Imglab.url("assets", "image.jpeg", width: 500, height: 600, mode: :contain, background_color: "255,0,0")
"https://cdn.imglab.io/assets/image.jpeg?width=500&height=600&mode=contain&background-color=255%2C0%2C0"

# Specifying a RGBA color as string
Imglab.url("assets", "image.jpeg", width: 500, height: 600, mode: :contain, background_color: "255,0,0,128")
"https://cdn.imglab.io/assets/image.jpeg?width=500&height=600&mode=contain&background-color=255%2C0%2C0%2C128"

# Specifying a named color as string
Imglab.url("assets", "image.jpeg", width: 500, height: 600, mode: :contain, background_color: "red")
"https://cdn.imglab.io/assets/image.jpeg?width=500&height=600&mode=contain&background-color=red"

# Specifying a hexadecimal color as string
Imglab.url("assets", "image.jpeg", width: 500, height: 600, mode: :contain, background_color: "F00")
"https://cdn.imglab.io/assets/image.jpeg?width=500&height=600&mode=contain&background-color=F00"
```

You can additionally use `Imglab::Color` helpers to specify these color values:

```ruby
# Remember to include Imglab::Color module before use these helpers
include Imglab::Color

# Using color helper for a RGB color
Imglab.url("assets", "image.jpeg", width: 500, height: 600, mode: "contain", background_color: color(255, 0, 0))
"https://cdn.imglab.io/assets/image.jpeg?width=500&height=600&mode=contain&background-color=255%2C0%2C0"

# Using color helper for a RGBA color
Imglab.url("assets", "image.jpeg", width: 500, height: 600, mode: "contain", background_color: color(255, 0, 0, 128))
"https://cdn.imglab.io/assets/image.jpeg?width=500&height=600&mode=contain&background-color=255%2C0%2C0%2C128"

# Using color helper for a named color
Imglab.url("assets", "image.jpeg", width: 500, height: 600, mode: "contain", background_color: color("red"))
"https://cdn.imglab.io/assets/image.jpeg?width=500&height=600&mode=contain&background-color=red"
```

> Note: specify hexadecimal color values using `Imglab::Color` helpers is not allowed. You can use strings instead.

### Specifying position parameters

Some imglab parameters can receive a position as value. It is possible to specify these values using strings:

```ruby
# Specifying a horizontal and vertical position as string
Imglab.url("assets", "image.jpeg", width: 500, height: 500, mode: "crop", crop: "left,top")
"https://cdn.imglab.io/assets/image.jpeg?width=500&height=500&mode=crop&crop=left%2Ctop"

# Specifying a vertical and horizontal position as string
Imglab.url("assets", "image.jpeg", width: 500, height: 500, mode: "crop", crop: "top,left")
"https://cdn.imglab.io/assets/image.jpeg?width=500&height=500&mode=crop&crop=top%2Cleft"

# Specifying a position as string
Imglab.url("assets", "image.jpeg", width: 500, height: 500, mode: "crop", crop: "left")
"https://cdn.imglab.io/assets/image.jpeg?width=500&height=500&mode=crop&crop=left"
```

You can additionally use `Imglab::Position` helpers to specify these position values:

```ruby
# Remember to include Imglab::Position module before use these helpers
include Imglab::Position

# Using position helper for a horizontal and vertical position
Imglab.url("assets", "image.jpeg", width: 500, height: 500, mode: "crop", crop: position("left", "top"))
"https://cdn.imglab.io/assets/image.jpeg?width=500&height=500&mode=crop&crop=left%2Ctop"

# Using position macro for a vertical and horizontal position
Imglab.url("assets", "image.jpeg", width: 500, height: 500, mode: "crop", crop: position("top", "left"))
"https://cdn.imglab.io/assets/image.jpeg?width=500&height=500&mode=crop&crop=top%2Cleft"

# Using position macro for a position
Imglab.url("assets", "image.jpeg", width: 500, height: 500, mode: "crop", crop: position("left"))
"https://cdn.imglab.io/assets/image.jpeg?width=500&height=500&mode=crop&crop=left"
```

### Specifying URL parameters

Some imglab parameters can receive URLs as values. It is possible to specify these parameter values as strings.

```ruby
Imglab.url("assets", "image.jpeg", width: 500, height: 600, watermark: "logo.svg")
"https://cdn.imglab.io/assets/image.jpeg?width=500&height=600&watermark=logo.svg"
```

And even use parameters if required:

```ruby
Imglab.url("assets", "image.jpeg", width: 500, height: 600, watermark: "logo.svg?width=100&format=png")
"https://cdn.imglab.io/assets/image.jpeg?width=500&height=600&watermark=logo.svg%3Fwidth%3D100%26format%3Dpng"
```

Additionally you can use nested `Imglab.url` calls to specify these URL values:

```ruby
Imglab.url(
  "assets",
  "image.jpeg",
  width: 500,
  height: 600,
  watermark: Imglab.url("assets", "logo.svg", width: 100, format: "png")
)
"https://cdn.imglab.io/assets/image.jpeg?width=500&height=600&watermark=https%3A%2F%2Fcdn.imglab.io%2Fassets%2Flogo.svg%3Fwidth%3D100%26format%3Dpng"
```

If the resource is located in a different source we can specify it using `Imglab.url`:

```ruby
Imglab.url(
  "assets",
  "image.jpeg",
  width: 500,
  height: 600,
  watermark: Imglab.url("marketing", "logo.svg", width: 100, format: "png")
)
"https://cdn.imglab.io/assets/image.jpeg?width=500&height=600&watermark=https%3A%2F%2Fcdn.imglab.io%2Fmarketing%2Flogo.svg%3Fwidth%3D100%26format%3Dpng"
```

Using secure sources for URLs parameter values is possible too:

```ruby
marketing_source = Imglab::Source.new("marketing", secure_key: "marketing-secure-key", secure_salt: "marketing-secure-salt")

Imglab.url(
  "assets",
  "image.jpeg",
  width: 500,
  height: 600,
  watermark: Imglab.url(marketing_source, "logo.svg", width: 100, format: "png")
)
```

`signature` query parameter will be automatically generated and attached to the nested URL value.

## Generating URLs for on-premises imglab server

For on-premises imglab server is possible to define custom sources pointing to your server location.

* `:https` - a `boolean` value specifying if the source should use https or not (default: `true`)
* `:host` - a `string` specifying the host where the imglab server is located. (default: `cdn.imglab.io`)
* `:port` - a `integer` specifying a port where the imglab server is located.
* `:subdomains` - a `boolean` value specifying if the source should be specified using subdomains instead of using the path. (default: `false`)

If we have our on-premises imglab server at `http://imglab.mycompany.com:8080` with a source named `web-images` we can use the following source settings to access a `logo.png` image:

```ruby
source = Imglab::Source.new("web-images", https: false, host: "imglab.mycompany.com", port: 8080)

Imglab.url(source, "logo.png", width: 300, height: 300, format: "png")
"http://imglab.mycompany.com:8080/web-images/logo.png?width=300&height=300&format=png"
```

It is possible to use secure sources too:

```ruby
source = Imglab::Source.new(
  "web-images",
  https: false,
  host: "imglab.mycompany.com",
  port: 8080,
  secure_key: "web-images-secure-key",
  secure_salt: "web-images-secure-salt"
)

Imglab.url(source, "logo.png", width: 300, height: 300, format: "png")
"http://imglab.mycompany.com:8080/web-images/logo.png?width=300&height=300&format=png&signature=generated-signature"
```

### Using sudomains sources

In the case that your on-premises imglab server is configured to use source names as subdomains you can set `subdomains` attribute to `true` to generate URLs using subdomains:

```ruby
source = Imglab::Source.new(
  "web-images",
  https: false,
  host: "imglab.mycompany.com",
  port: 8080,
  subdomains: true
)

Imglab.url(source, "marketing/logo.png", width: 300, height: 300, format: "png")
"http://web-images.imglab.mycompany.com:8080/marketing/logo.png?width=300&height=300&format=png"
```

## License

imglab source code is released under [MIT License](LICENSE).
