require 'pry'

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

  def +(other)
    result = self.dup
    size[0].times do |i|
      if size[1]
        size[1].times do |j|
          result[i][j] = result[i][j] + other[i][j]
        end
      else
        result[i] = result[i] + other[i]
      end
    end
    result
  end

  def dup
    Marshal.load(Marshal.dump(self))
  end

  def method_missing(m, ...)
    array.send(m, ...)
  end

  def self.zeros(size)
    result = nil
    size.reverse.each do |i|
      if result.nil?
        result = Array.new(i, 0)
      else
        result = Array.new(i) { deep_dup(result) }
      end
    end
    Matrix.new(result)
  end

  def self.test
    Matrix.new([[1,2,3],[4,5,6]])
  end

  private

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

  def self.range(first, delta, last=nil)
    result = Enumerator.new do |y|
      cursor = Matrix.new(first)
      loop do
        y << cursor.to_a
        cursor = cursor+delta
      end
    end
    result
  end

end


def parse_data(content, separator1, separator2=nil)
  content.split(separator1).map do |substring|
    separator2 ? substring.split(separator2) : substring
  end
end