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

# class Matrix(T)
#   private property content : Array(T)
#   getter dimensions = [1]
#   # private property dimensions = [1]

#   def initialize(default_value : T, *dimensions : Int32)
#     @dimensions = dimensions.to_a
#     @content = Array.new(dimensions.product, default_value)
#   end

#   def inspect
#     "#<#{self.class}:0x#{self.object_id.to_s(16)}, @dimensions=#{@dimensions.to_s}>"
#   end

# end

# alias RecArray = Array(Int32) | Array(String) | Array(RecArray)

# class MArray
#   def initialize(@array : RecArray)
#   end
# end

# bleh = MArray.new([[1,2,3],[4,5,6]].as(RecArray))

# class Array2 < Array(Array(String) | Array(Int32))

# end

# class Array2(T)
#   def initialize(@array : Array(Array(T)))
#   end

#   def [](i : Int32)
#     super
#   end

#   delegate push, to: @array
# end


def parse_data(content : String, separator1)
  content.split(separator1)
end

def parse_data(content : String, separator1, separator2)
  content.split(separator1).map do |substring|
    substring.split(separator2)
  end
end

def deep_dup(array : Array(Array))
  array.map(&.dup)
end

# def parse_other(content : String, separator1, separator2 = nil)
#   content.split(separator1).map do |substring|
#     separator2 ? substring.split(separator2) : substring
#   end
# end

puts "loaded common"