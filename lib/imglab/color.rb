module Imglab::Color
  extend self

  COLORS = %w[
    aliceblue
    antiquewhite
    aqua
    aquamarine
    azure
    beige
    bisque
    black
    blanchedalmond
    blue
    blueviolet
    brown
    burlywood
    cadetblue
    chartreuse
    chocolate
    coral
    cornflowerblue
    cornsilk
    crimson
    cyan
    darkblue
    darkcyan
    darkgoldenrod
    darkgray
    darkgreen
    darkgrey
    darkkhaki
    darkmagenta
    darkolivegreen
    darkorange
    darkorchid
    darkred
    darksalmon
    darkseagreen
    darkslateblue
    darkslategray
    darkslategrey
    darkturquoise
    darkviolet
    deeppink
    deepskyblue
    dimgray
    dimgrey
    dodgerblue
    firebrick
    floralwhite
    forestgreen
    fuchsia
    gainsboro
    ghostwhite
    gold
    goldenrod
    gray
    green
    greenyellow
    grey
    honeydew
    hotpink
    indianred
    indigo
    ivory
    khaki
    lavender
    lavenderblush
    lawngreen
    lemonchiffon
    lightblue
    lightcoral
    lightcyan
    lightgoldenrodyellow
    lightgray
    lightgreen
    lightgrey
    lightpink
    lightsalmon
    lightseagreen
    lightskyblue
    lightslategray
    lightslategrey
    lightsteelblue
    lightyellow
    lime
    limegreen
    linen
    magenta
    maroon
    mediumaquamarine
    mediumblue
    mediumorchid
    mediumpurple
    mediumseagreen
    mediumslateblue
    mediumspringgreen
    mediumturquoise
    mediumvioletred
    midnightblue
    mintcream
    mistyrose
    moccasin
    navajowhite
    navy
    oldlace
    olive
    olivedrab
    orange
    orangered
    orchid
    palegoldenrod
    palegreen
    paleturquoise
    palevioletred
    papayawhip
    peachpuff
    peru
    pink
    plum
    powderblue
    purple
    rebeccapurple
    red
    rosybrown
    royalblue
    saddlebrown
    salmon
    sandybrown
    seagreen
    seashell
    sienna
    silver
    skyblue
    slateblue
    slategray
    slategrey
    snow
    springgreen
    steelblue
    tan
    teal
    thistle
    tomato
    turquoise
    violet
    wheat
    white
    whitesmoke
    yellow
    yellowgreen
  ].freeze

  # Returns a formatted color value as string.
  #
  # @param args [Array<Integer>, String] the RGB, RGBA components as integers or a string with a named color.
  # @return [String] the formatted color with the specified arguments.
  # @raise [ArgumentError] when the specified arguments are not a valid color.
  #
  # @example Specify a RGB color
  #   Imglab::Color.color(255, 128, 128) #=> "255,128,128"
  # @example Specify a RGBA color
  #   Imglab::Color.color(255, 128, 128, 64) #=> "255,128,128,64"
  # @example Specify a named color
  #   Imglab::Color.color("white") #=> "white"
  # @example Specify an invalid RGB color (raising ArgumentError exception)
  #   Imglab::Color.color(256, 255, 255) #=> ArgumentError: Invalid color
  # @example Specify an invalid RGBA color (raising ArgumentError exception)
  #   Imglab::Color.color(255, 255, 255, 256) #=> ArgumentError: Invalid color
  # @example Specify an invalid named color (raising ArgumentError exception)
  #   Imglab::Color.color("blues") #=> ArgumentError: Invalid color
  def color(*args)
    case
    when args.size == 1 && COLORS.include?(args[0])
      args[0]
    when args.size == 3 && valid_components?(*args)
      args.join(",")
    when args.size == 4 && valid_components?(*args)
      args.join(",")
    else
      raise ArgumentError, "Invalid color"
    end
  end

  private

  def valid_components?(*components)
    components.all? { |component| valid_component?(component) }
  end

  def valid_component?(component)
    component.is_a?(Integer) && component >= 0 && component <= 255
  end
end
