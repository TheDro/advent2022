require "../common.cr"

content = File.read("./days/day01.data")

calories = content.split("\n")
totals = [0] of Int32
i = 0
calories.each do |calorie|
  if calorie.empty?
    totals.push(0)
  else
    totals[-1] += calorie.to_i
  end
end

top3 = totals.sort.reverse.first(3)
puts top3
puts top3.sum

debugger

puts "done"