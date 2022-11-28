puts "hello world"
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

img = [[0.1,0.8,0.1,0.9]]
imagesc(img)

# debugger

puts "done"