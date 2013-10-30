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
  end
  
  def update

    if @score == 0
      @particles.new_particle(x: 200, y: 150)
      @particles.new_particle(x: 300, y: 120)
    end

    @score += 1

    if button_down?(Gosu::MsLeft)
      return if @button_pressed
      @button_pressed = true

      @particles.new_particle(x: mouse_x, y: mouse_y)

    else
      @button_pressed = false
    end

    # if button_down?(Gosu::KbA)
      @particles.update
    # end
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
