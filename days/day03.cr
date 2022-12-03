require "../common.cr"

content = File.read("./days/day03.data")

bags = parse_data(content, "\n", "")

def part1(bags)
  doubles = [] of Char

  bags.each do |bag|
    left = bag.dup
    right = left.pop(left.size//2)
    doubles << (right&left)[0][0]
  end

  sum = 0
  doubles.each do |char|
    sum += priority(char)
  end

  puts "part 1: #{sum}"
  sum
end

def priority(char)
  char.ord <= 'Z'.ord ? char.ord - 'A'.ord + 27 : char.ord - 'a'.ord + 1
end


def part2(bags)
  commons = [] of Char

  (0..bags.size-1).step(3) do |i|
    bag1, bag2, bag3 = bags[i,3]
    common = bag1 & bag2 & bag3
    debugger if common.size < 1
    commons << common[0][0]
  end

  sum = commons.map {|char| priority(char)}.sum
  puts "part 2: #{sum}"
  sum
end



part1(bags)
part2(bags)


puts "done"