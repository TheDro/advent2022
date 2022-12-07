
class Matrix
  attr_accessor :array

  def initialize(array)
    @array = array
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

  def method_missing(m, ...)
    array.send(m, ...)
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





def parse_data(content, separator1, separator2=nil)
  content.split(separator1).map do |substring|
    separator2 ? substring.split(separator2) : substring
  end
end