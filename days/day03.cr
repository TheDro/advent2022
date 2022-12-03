require "../common.cr"

content = File.read("./days/day03.data")

bags = parse_data(content, "\n", "")

def part1(bags)
  doubles = [] of Char

  bags.each do |left|
    right = left.pop(left.size//2)
    doubles << (right&left)[0][0]
  end

  sum = 0
  doubles.each do |char|
    value = char.ord <= 'Z'.ord ? char.ord - 'A'.ord + 27 : char.ord - 'a'.ord + 1
    sum += value
  end

  puts "part 1: #{sum}"
  sum
end








part1(bags)

debugger

puts "done"