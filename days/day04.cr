require "../common.cr"

content = File.read("./days/day04.data")

range_pairs = parse_data(content, "\n", ",").map do |range_pair|
  left_range, right_range = range_pair
  left = left_range.split("-").map(&.to_i)
  right = right_range.split("-").map(&.to_i)
  if left[0] < right[0]
    [left,right]
  elsif left[0] == right[0]
    if left[1] > right[1]
      [left,right]
    else
      [right,left]
    end
  else
    [right,left]
  end
end
# First value of each pair of ranges is always the smallest (or equal) and if equal, the first range is largest
# [[3,5], [4,7]] or [[3,12],[3,8]] or [[3,7],[3,6]]

def full_overlaps(range_pairs)
  result = 0
  range_pairs.each do |pair|
    left,right = pair
    if left[1] >= right[1]
      result += 1
    end
  end
  result
end

def any_overlaps(range_pairs)
  result = 0
  range_pairs.each do |pair|
    left,right = pair
    if left[1] >= right[0]
      result += 1
    end
  end
  result
end


puts "part1: #{full_overlaps(range_pairs)}"
puts "part2: #{any_overlaps(range_pairs)}"

debugger

puts "done"