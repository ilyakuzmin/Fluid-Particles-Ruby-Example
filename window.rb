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
    if button_down?(Gosu::MsLeft)
      @particles.new_particle(x: mouse_x + rand(100) - 50, y: mouse_y + rand(100) - 50)
    end

    if button_down?(Gosu::KbA)
      return if @button_pressed2
      @button_pressed2 = true

      @particles.particles.clear
      draw_seeds
    else
      @button_pressed2 = false
    end

    if button_down?(Gosu::KbD)
      @particles.update
    end

    if button_down?(Gosu::KbY)
      $glob_K += 0.05
    end
    if button_down?(Gosu::KbH)
      $glob_K -= 0.05
    end
    if button_down?(Gosu::KbU)
      $glob_rest_ro += 0.05
    end
    if button_down?(Gosu::KbJ)
      $glob_rest_ro -= 0.05
    end
    if button_down?(Gosu::KbI)
      $glob_K_near += 0.05
    end
    if button_down?(Gosu::KbK)
      $glob_K_near -= 0.05
    end

    if button_down?(Gosu::KbQ)
      return if @button_pressed
      @button_pressed = true

      $show_radius = 1 - $show_radius
    else
      @button_pressed = false
    end

    @particles.update
  end

  def draw_seeds
    k = CONNECT_RADIUS * 2
    x_count = 300 / k
    y_count = 200 / k
    x = 1
    while (x < x_count )
      y = 1
      while (y < y_count)
        @particles.new_particle(x: 60 + x * k, y: 200 + y * k)
        y += 1
      end
      x += 1
    end
    @particles.new_particle(x: 305, y: 305)
  end
  
  def draw
    $font.draw("Particles: #{@particles.count}", 10, 10, 2, 1.0, 1.0, 0xffffff00)
    $font.draw("K: #{$glob_K}, rest_ro: #{$glob_rest_ro}, K_near: #{$glob_K_near}", 10, 28, 2, 1.0, 1.0, 0xffffff00)

    $font.draw("FPS: "+Gosu.fps.to_s, 580, 30, 2, 1.0, 1.0, 0xffffff00)

    @particles.draw
  end

  def needs_cursor?
    true
  end
end

$window = GameWindow.new
$font = Gosu::Font.new($window, Gosu::default_font_name, 14)
$window.show
