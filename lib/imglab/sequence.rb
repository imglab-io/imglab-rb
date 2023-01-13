module Imglab::Sequence
  extend self

  DEFAULT_SIZE = 16

  # Returns a geometric sequence of integer numbers inside an interval and with specific size as array.
  #
  # @param first [Integer] the first integer number of the sequence.
  # @param last [Integer] the last integer number of the sequence.
  # @param size [Integer] the size of the sequence.
  # @return [Array<Integer>] a sequence of integer numbers as array.
  #
  # @example Specify an ascending sequence of default size
  #   Imglab::Sequence.sequence(100, 8192) #=> [100, 134, 180, 241, 324, 434, 583, 781, 1048, 1406, 1886, 2530, 3394, 4553, 6107, 8192]
  # @example Specify an ascending sequence of size 1
  #   Imglab::Sequence.sequence(100, 8192, 1) #=> [100]
  # @example Specify an ascending sequence of size 2
  #   Imglab::Sequence.sequence(100, 8192, 2) #=> [100, 8192]
  # @example Specify an ascending sequence of size 4
  #   Imglab::Sequence.sequence(100, 8192, 4) #=> [100, 434, 1886, 8192]
  # @example Specify a descending sequence of size 6
  #   Imglab::Sequence.sequence(70, 60, 6) #=> [70, 68, 66, 64, 62, 60]
  def sequence(first, last, size = DEFAULT_SIZE)
    return [] if size <= 0
    return [first] if size == 1
    return [first, last] if size == 2

    ratio = (last / first.to_f) ** (1 / (size - 1).to_f)

    progression(first, ratio).take(size - 1).map(&:round).push(last)
  end

  private

  def progression(first, ratio)
    n = first

    Enumerator.new do |y|
      loop do
        y << n
        n *= ratio
      end
    end
  end
end
