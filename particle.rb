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
CONNECT_RADIUS = 15
CONNECT_RADIUS_2 = CONNECT_RADIUS * CONNECT_RADIUS
DIAMETR = CONNECT_RADIUS * 2
CELLS_X = 640 / DIAMETR
CELLS_Y = 480 / DIAMETR
$glob_K = 0.1
$glob_rest_ro = 0.5
$glob_K_near = 0.5
$show_radius = 0

class Particles
  attr_accessor :particles

  def initialize
    @particles = []
  end

  def new_particle(attrs)
    @particles << Particle.new(attrs[:x], attrs[:y])
  end

  def update
    # Greed
    @grid = []
    @particles.each do |particle|
      x, y = particle.pos_in_grid
      @grid[x] ||= []
      @grid[x][y] ||= []
      @grid[x][y] << particle
    end

    @particles.each do |particle|
      particle.ro = 0
      particle.ro_near = 0
      particle.press = 0
      particle.press_near = 0
    end

    # @particles.each do |particle|
      # (@particles - [particle]).each do |particle2|
    CELLS_X.times do |x|
      CELLS_Y.times do |y|
        next unless @grid[x].is_a?(Array) && @grid[x][y].is_a?(Array)

        big_cell = []
        (-1..1).to_a.each do |x2|
          (-1..1).to_a.each do |y2|
            big_cell << @grid[x-x2][y-y2] if @grid[x-x2] && @grid[x-x2][y-y2]
          end
        end
        big_cell.flatten!.compact!

        @grid[x][y].each do |particle|
          (big_cell - [particle]).each do |particle2|

            r_square = (particle2.position.x - particle.position.x)**2 + (particle2.position.y - particle.position.y)**2

            if r_square < CONNECT_RADIUS_2

              q = (r_square / CONNECT_RADIUS_2)

              if q < 1
                q = 1 - q
                q2 = q * q

                particle.ro += q2
                particle.ro_near += q2 * q
              end
            end
          end

          particle.press = $glob_K * (particle.ro - $glob_rest_ro) # K, rest_ro
          particle.press_near = $glob_K_near * particle.ro_near # K_near


          sx = 0
          sy = 0
          (big_cell - [particle]).each do |particle2|
            r_square = (particle2.position.x - particle.position.x)**2 + (particle2.position.y - particle.position.y)**2
            r = Math.sqrt(r_square)

            if r < CONNECT_RADIUS

              if r / CONNECT_RADIUS < 1
              factor_x = particle2.position.x - particle.position.x
              factor_y = particle2.position.y - particle.position.y

              eps = 0.01
              if (factor_x < eps) || (factor_y < eps)
                particle.position.x += rand(100)/10000.0 * PlusMinus.get
                particle.position.y += rand(100)/10000.0 * PlusMinus.get
              end

              q = 1 - (r / CONNECT_RADIUS)
              tmp = q*((particle.press) + (particle.press_near)*q)/r

              visc = 2

              particle2.boost.x += factor_x * tmp * visc / 2.0
              particle2.boost.y += factor_y * tmp * visc / 2.0
              sx -= factor_x * tmp * visc / 2.0
              sy -= factor_y * tmp * visc / 2.0
              end
            end
          end

          particle.boost.x += sx
          particle.boost.y += sy
        end
      end
    end

    # Position
    @particles.each do |particle|
      particle.boost.y += 0.1
      particle.position += particle.boost

      if particle.position.y > 400
        particle.boost.y *= -0.3
        particle.boost.y -= 0.5
        particle.position.y = 400.0
      end

      if particle.position.x > 501
        particle.boost.x *= -0.3
        particle.position.x = 500.0
      end

      if particle.position.x < 49
        particle.boost.x *= -0.3
        particle.position.x = 50.0
      end
      @count_d ||= 0
      if particle.position.x > 640 || particle.position.x < 0 ||
          particle.position.y > 480 ||
          particle.position.x.nan? || particle.position.y.nan?
        @particles.delete(particle)
        @count_d += 1
        puts "DELETED #{@count_d}"
      end
    end
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

    @image3  = Gosu::Image.new($window, Circle.new(CONNECT_RADIUS), true)
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

    if $show_radius == 1
      @image3.draw(x, y, 1);
    end
  end

  def update

  end

  def pos_in_grid
    return (position.x / DIAMETR).round, (position.y / DIAMETR).round
  end

  def debug
    "X: #{@position.x.round(1)}, Y: #{@position.y.round(1)}"+ #, R: #{radius.round(1)}, "
    "ro: #{self.ro.round(1)}, ro_near: #{self.ro_near.round(1)}"+ #, R: #{radius.round(1)}, "
    "press: #{self.press.round(1)}, press_near: #{self.press_near.round(1)}" #, R: #{radius.round(1)}, "
    # "B_X: #{@boost.x.round(1)}, B_Y: #{@boost.y.round(1)}, "+
    # "V_X: #{@velocity.x.round(1)}, V_Y: #{@velocity.y.round(1)}, "
  end
end
