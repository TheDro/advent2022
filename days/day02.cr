require "../common.cr"

content = File.read("./days/day02.data")

rounds = parse_data(content, "\n", " ")

scorecard = {
  "A" => {"X" => 1+3, "Y" => 2+6, "Z" => 3+0}, 
  "B" => {"X" => 1+0, "Y" => 2+3, "Z" => 3+6}, 
  "C" => {"X" => 1+6, "Y" => 2+0, "Z" => 3+3}, 
}


total = 0
rounds.each do |round|
  total += scorecard[round[0]][round[1]]
end


scorecard2 = {
  "A" => {"X" => 3+0, "Y" => 1+3, "Z" => 2+6}, 
  "B" => {"X" => 1+0, "Y" => 2+3, "Z" => 3+6}, 
  "C" => {"X" => 2+0, "Y" => 3+3, "Z" => 1+6}, 
}

total2 = 0
rounds.each do |round|
  total2 += scorecard2[round[0]][round[1]]
end

puts total
puts total2


puts "done"