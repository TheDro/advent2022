require "../common.cr"

content = File.read("./days/day06.data")
# content = "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"

letters = parse_data(content, "")


def part1(letters)
  (0..letters.size-4).each do |i|
    if all_unique?(letters[i,4])
      return i+4
    end
  end
end

def part2(letters)
  (0..letters.size-14).each do |i|
    if all_unique?(letters[i,14])
      return i+14
    end
  end
end


def all_unique?(letters)
  letters.size == letters.uniq.size
end


puts "part1: #{part1(letters)}"
puts "part1: #{part2(letters)}"

debugger
puts "done"

