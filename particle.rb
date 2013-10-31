class Vector
  attr_accessor :x, :y, :angle

  def initialize(x = 0, y = 0)
    @x = Float(x)
    @y = Float(y)
  end

  def +(val)
    if val.is_a?(Vector)
      self.x += val.x
      self.y += val.y
    else
      self.x += val
      self.y += val
    end
    return self
  end

  def ==(val)
    self.x == val.x && self.y == val.y
  end
end

G = 40
PARTICLE_RADIUS = 3
CONNECT_RADIUS = 50

class Particles
  attr_accessor :particles

  def initialize
    @particles = []
  end

  def new_particle(attrs)
    @particles << Particle.new(attrs[:x], attrs[:y])
  end

  def update
    @particles.each do |particle|
      particle.ro = 0
      particle.ro_near = 0
      particle.press = 0
      particle.press_near = 0
    end

    # Boost
    @particles.each do |particle|
      (@particles - [particle]).each do |particle2|
        r_square = (particle2.position.x - particle.position.x)**2 + (particle2.position.y - particle.position.y)**2
        r = Math.sqrt(r_square)

        if r < CONNECT_RADIUS

          q = 1 - (r / CONNECT_RADIUS)
          q2 = q * q

          particle.ro += q2
          particle.ro_near += q2 * q
        end
      end
    # end

    # @particles.each do |particle|
      particle.press = 10 * (particle.ro - 5) # K, rest_ro
      particle.press_near = 20 * particle.ro_near # K_near
    # end

    # @particles.each do |particle|
      sx = 0
      sy = 0
      (@particles - [particle]).each do |particle2|
        r_square = (particle2.position.x - particle.position.x)**2 + (particle2.position.y - particle.position.y)**2
        r = Math.sqrt(r_square)

        if r < CONNECT_RADIUS
          factor_x = (particle2.position.x - particle.position.x)
          factor_y = (particle2.position.y - particle.position.y)

          q = 1 - (r / CONNECT_RADIUS)
          # tmp = q*((particle.press + particle2.press) + (particle.press_near + particle2.press_near)*q)/r
          tmp = q*((particle.press) + (particle.press_near)*q)/(r*2)

          visc = 0.1

          particle2.boost.x += factor_x * tmp * visc
          particle2.boost.y += factor_y * tmp * visc
          sx += factor_x * tmp * visc
          sy += factor_y * tmp * visc
        end
      end

      particle.boost.x -= sx
      particle.boost.y -= sy
    end

    # Position
    @particles.each do |particle|
      particle.boost.y += 0.1
      particle.position += particle.boost

      if particle.position.y > 400
        particle.boost.y *= -0.1
        particle.position.y = 400
      end

      if particle.position.x > 500
        particle.boost.x *= -0.1
        particle.position.x = 500
      end

      if particle.position.x < 50
        particle.boost.x *= -0.1
        particle.position.x = 50
      end
    end

    # @particles.each do |particle|
    #   i = 0
    #   (@particles - [particle]).each do |particle2|
    #     if particle.position == particle2.position
    #       # puts "COLL #{i}"
    #       i += 1
    #     end
    #   end
    # end
  end

  def draw
    i = 0
    @particles.each do |p|
      p.draw

      # $font.draw(p.debug, 10, 28 + (i*18), 2, 1.0, 1.0, 0xffffff00)
      i += 1
    end
  end

  def count
    @particles.count
  end
end

class Particle
  attr_accessor :position, :radius, :velocity, :boost, :ro, :ro_near, :press, :press_near

  def initialize(x = 0, y = 0)
    @position = Vector.new(x - PARTICLE_RADIUS, y - PARTICLE_RADIUS)
    @velocity = Vector.new
    @boost = Vector.new
    @radius = 0

    @r_square = 0

    # @image3  = Gosu::Image.new($window, Circle.new(CONNECT_RADIUS), true)
    # @image4  = Gosu::Image.new($window, Circle.new(CONNECT_RADIUS-1, Circle::BLACK), true)

    @image  = Gosu::Image.new($window, Circle.new(PARTICLE_RADIUS), true)
    @image2 = Gosu::Image.new($window, Circle.new(PARTICLE_RADIUS-1, Circle::BLACK), true)
  end

  def draw
    x = @position.x-CONNECT_RADIUS+PARTICLE_RADIUS
    y = @position.y-CONNECT_RADIUS+PARTICLE_RADIUS
    # @image3.draw(x, y, 1);
    # @image4.draw(x+1, y+1, 1);

    @image.draw(@position.x, @position.y, 1);
    @image2.draw(@position.x+1, @position.y+1, 1);
  end

  def update

  end

  def debug
    "X: #{@position.x.round(1)}, Y: #{@position.y.round(1)}, R: #{radius.round(1)}, "
    # "B_X: #{@boost.x.round(1)}, B_Y: #{@boost.y.round(1)}, "+
    # "V_X: #{@velocity.x.round(1)}, V_Y: #{@velocity.y.round(1)}, "
  end
end
