require 'pry'
load 'common.rb'
# content = File.read("./days/day10.data")
content = File.read("./days/day10.test.data")
$instructions = parse_data(content,"\n")

# remove from beginning: shift
# add to end: push

def generate_signals(instructions = $instructions)
  $signals = Array.new(instructions.length+2){0}
  commands = []
  cursor = 1
  instructions.each_index do |i|
    instruction = instructions[i]
    
    if /noop/.match(instruction)
      commands.push(0)
    elsif value = /addx ([-0-9]+)/.match(instruction)
      commands.push(0)
      commands.push(value[1].to_i)
    end
    $signals[i] = cursor
    if current_command = commands.shift
      cursor = cursor + current_command
    end
    
  end
  while !commands.empty?
    cursor = cursor + commands.shift
    $signals.push(cursor)
  end

  $signals
end

# 12780 is too high :(
# 11380 is too low :(
def part1
  result = 0
  signals = generate_signals
  (20..(signals.length-1)).step(40).each do |i|
    puts "cycle #{i}: #{signals[i-1]}"
    result += signals[i-1]*i
  end
  result
end

generate_signals($instructions)
pp (1..$signals.length).zip($signals)
pp part1