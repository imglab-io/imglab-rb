module Imglab::Position
  extend self

  HORIZONTAL = %w[left center right]
  VERTICAL = %w[top middle bottom]

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
