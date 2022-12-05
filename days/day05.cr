require "../common.cr"

content = File.read("./days/day05.data")

stacks, moves = parse_data(content, "\n\n")
stacks = parse_stacks(stacks.split("\n"))
moves = parse_moves(moves.split("\n"))

stacks1 = deep_dup(stacks)
apply_moves(stacks1, moves)
puts "part1: #{stacks1.map(&.last).join}"


stacks2 = deep_dup(stacks)
apply_big_moves(stacks2, moves)
puts "part2: #{stacks2.map(&.last).join}"


debugger
puts "done"



def apply_big_moves(stacks, moves)
  return if stacks.nil?
  moves.each do |move|
    values = stacks[move[1]-1].pop(move[0])
    stacks[move[2]-1].concat(values)
  end
end


def apply_moves(stacks, moves)
  return if stacks.nil?
  moves.each do |move|
    puts ""
    move[0].times do 
      value = stacks[move[1]-1].pop
      stacks[move[2]-1].push(value)
    end
  end
end

def parse_moves(moves)
  phrase = /move (\d+) from (\d+) to (\d+)/

  result = moves.map do |move|
    matches = move.match(phrase).as(Regex::MatchData)
    matches.to_a[1..3].map do |value| 
      value ? value.to_i : 0
    end
  end
end

def parse_stacks(stacks)
  result = stacks.map do |row|
    crates = row.split("").in_groups_of(4).map { |group| group[1] }
  end
  result = result.transpose
  result = result.map(&.reverse)
  result.each { |stack| stack.delete(" ") }
  result
end
