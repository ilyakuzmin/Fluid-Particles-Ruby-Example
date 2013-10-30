class Vector
  attr_accessor :x, :y, :angle

  def initialize(x = 0, y = 0)
    @x = Float(x)
    @y = Float(y)
  end
end

G = 12
PARTICLE_RADIUS = 8
CONNECT_RADIUS = 20
CONNECT_RADIUS_SQUARE = CONNECT_RADIUS**2

class Particles
  def initialize
    @particles = []
  end

  def new_particle(attrs)
    @particles << Particle.new(attrs[:x], attrs[:y])
  end

  def update
    # Boost
    @particles.each do |particle|
      particle.boost.x = 0
      particle.boost.y = 0
      (@particles - [particle]).each do |particle2|
        r_square = (particle2.position.x - particle.position.x)**2 + (particle2.position.y - particle.position.y)**2

        if r_square > CONNECT_RADIUS_SQUARE
          r = Math.sqrt(r_square)
          factor_x = (particle2.position.x - particle.position.x) / r
          factor_y = (particle2.position.y - particle.position.y) / r

          particle.radius = r
          particle.boost.x += factor_x * G / r_square
          particle.boost.y += factor_y * G / r_square
        end
      end
    end

    # Velocity
    @particles.each do |particle|
      particle.velocity.x += particle.boost.x
      particle.velocity.y += particle.boost.y

      particle.position.x += particle.velocity.x
      particle.position.y += particle.velocity.y
    end
  end

  def draw
    i = 0
    @particles.each do |p|
      p.draw

      $font.draw(p.debug, 10, 28 + (i*18), 2, 1.0, 1.0, 0xffffff00)
      i += 1
    end
  end

  def count
    @particles.count
  end
end

class Particle
  attr_accessor :position, :radius, :velocity, :boost

  def initialize(x = 0, y = 0)
    @position = Vector.new(x - PARTICLE_RADIUS, y - PARTICLE_RADIUS)
    @velocity = Vector.new
    @boost = Vector.new
    @radius = 0

    @r_square = 0

    @image  = Gosu::Image.new($window, Circle.new(PARTICLE_RADIUS), true)
    @image2 = Gosu::Image.new($window, Circle.new(PARTICLE_RADIUS-1, Circle::BLACK), true)
  end

  def draw
    @image.draw(@position.x, @position.y, 1);
    @image2.draw(@position.x+1, @position.y+1, 1);
  end

  def update

  end

  def debug
    "X: #{@position.x.round(1)}, Y: #{@position.y.round(1)}, R: #{radius.round(1)}, "+
    "B_X: #{@boost.x.round(1)}, B_Y: #{@boost.y.round(1)}, "+
    "V_X: #{@velocity.x.round(1)}, V_Y: #{@velocity.y.round(1)}, "
  end
end
