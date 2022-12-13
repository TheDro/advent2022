load 'common.rb'
require 'json'
content = File.read("./days/day13.data")
# content = File.read("./days/day13.test.data")
$data = parse_data(content,"\n\n", "\n")
$data = $data.map do |pair|
  pair.map do |signal|
    JSON.parse(signal)
  end
end

def is_sorted(a, b)
  if a.is_a?(Integer) && b.is_a?(Array)
    return is_sorted([a], b)
  elsif a.is_a?(Array) && b.is_a?(Integer)
    return is_sorted(a, [b])
  elsif a.is_a?(Integer) && b.is_a?(Integer)
    return a <=> b
  end

  default_result = a.size <=> b.size
  [a.size, b.size].min.times do |i|
    comparison = is_sorted(a[i], b[i])
    if comparison != 0
      return comparison
    end
  end
  default_result
end

def part1
  result = 0
  $data.size.times do |i|
    if is_sorted(*$data[i]) == -1
      result += i+1
    end
  end
  result
end

def part2
  data = $data.dup.flatten(1)
  data.push([[2]])
  data.push([[6]])

  sorted_data = data.sort do |a,b|
    is_sorted(a,b)
  end

  index_2 = 0
  index_6 = 0
  sorted_data.size.times do |i|
    if sorted_data[i].to_json == "[[2]]"
      index_2 = i+1
    elsif sorted_data[i].to_json == "[[6]]"
      index_6 = i+1
    end
  end
  index_2*index_6
end

# puts part1
puts part2



