require "stumpy_png"
include StumpyPNG

def imagesc(img)
  maxVal = 1.0
  nx = img.size
  ny = img[0].size
  canvas = Canvas.new(nx,ny)
  (0..nx-1).each do |i|
    (0..ny-1).each do |j|
      value = (img[i][j]/maxVal*255).to_i
      canvas[i,j] = RGBA.from_rgb(value,value/2,value/4)
    end
  end
  StumpyPNG.write(canvas, "output1.png")
  canvas
end

class Matrix(T)
  private property content : Array(T)
  getter dimensions = [1]
  # private property dimensions = [1]

  def initialize(default_value : T, *dimensions : Int32)
    @dimensions = dimensions.to_a
    @content = Array.new(dimensions.product, default_value)
  end

  def inspect
    "#<#{self.class}:0x#{self.object_id.to_s(16)}, @dimensions=#{@dimensions.to_s}>"
  end

end

puts "loaded common"