class Circle
  WHITE = "\xff\xff\xff"
  BLACK = "\x00\x00\x00"

  attr_reader :columns, :rows

  def initialize(radius, color = WHITE)
    @columns = @rows = radius * 2
    lower_half = (0...radius).map do |y|
      x = Math.sqrt(radius**2 - y**2).round
      right_half = "#{"\xff" * x}#{"\x00" * (radius - x)}"
      "#{right_half.reverse}#{right_half}"
    end.join
    @blob = lower_half.reverse + lower_half
    @blob.gsub!(/./) { |alpha| "#{color}#{alpha}"}
  end

  def to_blob
    @blob
  end
end

class PlusMinus
  def self.get
    rand(2).zero? ? 1 : -1
  end
end
