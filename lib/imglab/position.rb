module Imglab::Position
  extend self

  HORIZONTAL = %w[left center right]
  VERTICAL = %w[top middle bottom]

  # Returns a formatted position value as string.
  #
  # @param args [Array<String>, String] the position with two directions or one single direction as strings.
  # @return [String] the formatted position with the specified arguments.
  # @raise [ArgumentError] when the specified arguments are not a valid position.
  #
  # @example Specify a double direction position (horizontal, vertical order)
  #   Imglab::Position.position("left", "bottom") #=> "left,bottom"
  # @example Specify a double direction position (vertical, horizontal order)
  #   Imglab::Position.position("bottom", "left") #=> "bottom,left"
  # @example Specify a single direction position
  #   Imglab::Position.position("left") #=> "left"
  # @example Specify an invalid double direction position (raising ArgumentError exception)
  #   Imglab::Position.position("left", "center") #=> ArgumentError: Invalid position
  # @example Specify an invalid single direction position (raising ArgumentError exception)
  #   Imglab::Position.position("lefts") #=> ArgumentError: Invalid position
  def position(*args)
    case
    when args.size == 1 && valid_position?(args[0])
      args[0]
    when args.size == 2 && valid_position?(*args)
      args.join(",")
    else
      raise ArgumentError.new("Invalid position")
    end
  end

  private

  def valid_position?(*args)
    case
    when args.size == 1 && valid_direction?(args[0])
      true
    when args.size == 2 && valid_directions?(args[0], args[1])
      true
    else
      false
    end
  end

  def valid_direction?(direction)
    HORIZONTAL.include?(direction) || VERTICAL.include?(direction)
  end

  def valid_directions?(direction_a, direction_b)
    (HORIZONTAL.include?(direction_a) && VERTICAL.include?(direction_b)) ||
    (HORIZONTAL.include?(direction_b) && VERTICAL.include?(direction_a))
  end
end
