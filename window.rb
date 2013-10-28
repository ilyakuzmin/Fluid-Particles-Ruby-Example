require 'gosu'
require './trash'
require './particle'

class GameWindow < Gosu::Window
  def initialize
    super 640, 480, false
    self.caption = "Gosu Tutorial Game"

    @font = Gosu::Font.new(self, Gosu::default_font_name, 14)

    @particles = []
    @score = 0

    @button_pressed = false
  end
  
  def update
    @score += 1

    if button_down?(Gosu::MsLeft)
      return if @button_pressed
      @button_pressed = true

      particle = Particle.new(mouse_x, mouse_y)
      @particles << particle
    else
      @button_pressed = false
    end
  end
  
  def draw
    @font.draw("Particles: #{@particles.count}", 10, 10, 2, 1.0, 1.0, 0xffffff00)
    i = 0
    @particles.each do |p|
      p.draw

      # Debug & Test
      @font.draw(p.debug, 10, 28 + (i*18), 2, 1.0, 1.0, 0xffffff00)
      p.position.x += Float(rand(100))*0.01 * PlusMinus.get
      p.position.y += Float(rand(100))*0.01 * PlusMinus.get
      i += 1
    end
  end

  def needs_cursor?
    true
  end
end

$window = GameWindow.new
$window.show
