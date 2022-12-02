require "../common.cr"

content = File.read("./days/day01.data")

calories = parse_data(content, "\n\n", "\n")

totals = calories.map do |group|
  # next 0 if group.is_a?(String)
  group.map(&.to_i).sum
end

top3 = totals.sort.reverse.first(3)

debugger

puts "done"