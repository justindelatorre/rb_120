=begin
Given the below class, write a class Square that inherits from Rectangle, and
is used like the example below.

Example:
square = Square.new(5)
puts "area of square = #{square.area}"
=end

class Rectangle
  def initialize(height, width)
    @height = height
    @width = width
  end

  def area
    @height * @width
  end
end

class Square < Rectangle
  def initialize(side_length)
    super(side_length, side_length)
  end
end

square = Square.new(5)
puts "area of square = #{square.area}"
