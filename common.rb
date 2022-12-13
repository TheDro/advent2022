require 'pry'
require 'pry-nav'
require 'chunky_png'
# irb -r ./common.rb

def deep_dup(object)
  Marshal.load(Marshal.dump(object))
end


class Matrix
  attr_accessor :array

  def initialize(array)
    if array.is_a?(Matrix)
      @array = deep_dup(array.array)
    else
      @array = array
    end
  end

  def size(n=nil)
    result = [array.size]
    if array[0].is_a?(Array)
      result.concat(Matrix.new(array[0]).size)
    end

    return result[n] if n
    result
  end

  def each_index
    size = self.size
    product = size.reduce(1) { |prod, x| x*prod }
    product.times do |i|
      yield *get_indexes(i, size)
    end
  end

  def [](*args)
    if args.size == 1 && (args[0].is_a?(Array) || args[0].is_a?(Matrix))
      result = array
      args[0].each do |i|
        result = result&.[](i)
      end
      return result
    end
    return array[*args]
  end

  def []=(*args)
    if args.size == 2 && (args[0].is_a?(Array) || args[0].is_a?(Matrix))
      new_value = args[1]
      result = array
      args[0][0..-2].each do |i|
        result = result&.[](i)
      end
      return result[args[0][-1]] = new_value
    end
    return array.[]=(*args)
  end

  def *(number)
    result = self.dup
    size = result.size
    size[0].times do |i|
      if size[1]
        size[1].times do |j|
          result[i][j] = result[i][j] * number
        end
      else
        result[i] = result[i] * number
      end
    end
    result
  end


  def add!(other)
    result = self

    if self.size.size == 1
      result.array = result.array.zip(other).map do |a,b|
        a + b
      end
      return result
    else
      result.array = result.array.zip(other).map do |row_a, row_b|
        row_a.zip(row_b).map do |a,b|
          a + b
        end
      end
      return result
    end
  end

  def +(other)
    self.dup.add!(other)
  end

  def subtract!(other)
    result = self

    if self.size.size == 1
      result.array = result.array.zip(other).map do |a,b|
        a - b
      end
      return result
    else
      result.array = result.array.zip(other).map do |row_a, row_b|
        row_a.zip(row_b).map do |a,b|
          a - b
        end
      end
      return result
    end
  end

  def -(other)
    self.dup.subtract!(other)
  end

  def dup
    Marshal.load(Marshal.dump(self))
  end

  def to_m
    self
  end

  def method_missing(m, ...)
    array.send(m, ...)
  end

  def self.zeros(size)
    same_values(size, 0)
  end

  def self.ones(size)
    same_values(size, 1)
  end

  def self.test
    Matrix.new([[1,2,3],[4,5,6]])
  end

  private

  def self.same_values(size, value)
    result = nil
    size.reverse.each do |i|
      if result.nil?
        result = Array.new(i, value)
      else
        result = Array.new(i) { deep_dup(result) }
      end
    end
    Matrix.new(result)
  end

  def get_indexes(n, size)
    result = []
    size.each_index do |i|
      after = size[(i+1)..].reduce(1) { |prod, x| x*prod }
      if i == 0
        result.push(n/after)
      else
        result.push((n/after)%size[i])
      end
    end
    result
  end
end

class Vectors
  # bounds are inclusive
  def self.range(first, delta, bounds=nil)
    result = Enumerator.new do |y|
      cursor = first.dup
      if bounds
        catch :out_of_bounds do
          loop do
            throw :out_of_bounds if cursor.min < 0
            throw :out_of_bounds if (cursor.zip(bounds).map{|a,b| a-b}).max > 0
            y << cursor
            cursor = cursor.zip(delta).map{|a,b| a+b}
          end
        end
      else
        loop do
          y << cursor.to_a
          cursor = cursor + delta
        end
      end
    end
    result
  end

end

class Array
  def to_m
    Matrix.new(self)
  end
end

class Timer
  def self.tic
    @@tic = Time.now
  end
  def self.toc
    result = Time.now - @@tic
    @@tic = Time.now
    puts result
    result
  end
end


def tic
  Timer.tic
end

def toc
  Timer.toc
end

def parse_data(content, separator1, separator2=nil)
  content.split(separator1).map do |substring|
    separator2 ? substring.split(separator2) : substring
  end
end


def dd
  load 'days/day13.rb'
end

def setup(today = Time.now.day)
  # copy file from one location to another
  yesterday = today-1
  yesterday_name = "day" + "0#{yesterday}"[-2..]
  today_name = "day" + "0#{today}"[-2..]
  yesterday_filename = "./days/#{yesterday_name}.rb"
  today_filename = "./days/#{today_name}.rb"
  if !File.exists?(today_filename)
    FileUtils.cp(yesterday_filename, today_filename)
    FileUtils.touch("./days/#{today_name}.data")
    FileUtils.touch("./days/#{today_name}.test.data")
  end
end


def imagesc(img, number = 0)
  img = img.to_m
  max_value = img.map(&:max).max
  scale = 255.0/max_value
  png = ChunkyPNG::Image.new(img.size[1], img.size[0], ChunkyPNG::Color::TRANSPARENT)
  img.each_with_index do |row, i|
    row.each_with_index do |value, j|
      color = (value*scale).round
      png[j,i] = ChunkyPNG::Color.rgba(color, color, color, 255)
    end
  end
  png.save("./days/output#{number}.png")
end


# def test
#   n = 500 
#   mat = Matrix.ones([n,n])
#   tic
#   total = 0
#   Vectors.range([0,0],[0,1],[n-1,n-1]).each do |i|
#     Vectors.range(i,[1,0],[n-1,n-1]).each do |pos|
#       total += mat[pos]
#     end
#   end
#   puts "  #{total}"
#   toc # n=500: 4.6, 5.1, 2.7, 2.6 ?? 3.2, 2.9, 0.54
# end

# def test2
#   n = 500 
#   mat = Matrix.ones([n,n])
#   tic
#   total = 0
#   n.times do |i|
#     n.times do |j|
#       total += mat[i][j]
#     end
#   end
#   puts "  #{total}"
#   toc # n=500: 0.11
# end

# test
# test
# test
# test2
# test2
# test2
