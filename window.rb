require 'gosu'
require './trash'
require './particle'

class GameWindow < Gosu::Window
  def initialize
    super 640, 480, false
    self.caption = "Gosu Tutorial Game"

    @particles = Particles.new

    @score = 0

    @button_pressed = false
    @button_pressed2 = false
  end
  
  def update

    if @score == 0
      # @particles.new_particle(x: 200, y: 350)
      # @particles.new_particle(x: 210, y: 350)
      # @particles.new_particle(x: 200, y: 340)
      # @particles.new_particle(x: 215, y: 350)
      # @particles.new_particle(x: 220, y: 350)
      # @particles.new_particle(x: 225, y: 350)
      # @particles.new_particle(x: 230, y: 350)
    end

    @score += 1


    if button_down?(Gosu::MsLeft)
      # return if @button_pressed
      # @button_pressed = true

      @particles.new_particle(x: mouse_x + rand(100) - 50, y: mouse_y + rand(100) - 50)
    else
      # @button_pressed = false
    end

    if button_down?(Gosu::KbA)
      return if @button_pressed2
      @button_pressed2 = true

      # @particles.update

      @particles.particles.clear
      @particles.new_particle(x: 200, y: 350)
      @particles.new_particle(x: 210, y: 350)
      @particles.new_particle(x: 200, y: 340)
      @particles.new_particle(x: 210, y: 340)
    else
      @button_pressed2 = false
    end
    @particles.update

    if button_down?(Gosu::KbS)
      return if @button_pressed
      @button_pressed = true
      
      @particles.update
    else
      @button_pressed = false
    end

    if button_down?(Gosu::KbD)
      @particles.update
    end


    if button_down?(Gosu::KbS)
      @particles.particles.each do |particle|
        particle.velocity.x *= 0.9
        particle.velocity.y *= 0.9
      end
    end
  end
  
  def draw
    $font.draw("Particles: #{@particles.count}", 10, 10, 2, 1.0, 1.0, 0xffffff00)

    @particles.draw
  end

  def needs_cursor?
    true
  end
end

$window = GameWindow.new
$font = Gosu::Font.new($window, Gosu::default_font_name, 14)
$window.show
