class Vector
  attr_accessor :x, :y, :angle

  def initialize(x = 0, y = 0)
    @x = Float(x)
    @y = Float(y)
  end
end

class Particle
  attr_accessor :position

  def initialize(x = 0, y = 0, size = 16)
    @position = Vector.new(x - size, y - size)
    @velocity = Vector.new

    @image  = Gosu::Image.new($window, Circle.new(size), true)
    @image2 = Gosu::Image.new($window, Circle.new(size-1, Circle::BLACK), true)
  end

  def draw
    @image.draw(@position.x, @position.y, 1);
    @image2.draw(@position.x+1, @position.y+1, 1);
  end

  def debug
    "X: #{@position.x}, Y: #{@position.y}"
  end
end



