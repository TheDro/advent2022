require 'pry'
load 'common.rb'
content = File.read("./days/day10.data")
# content = File.read("./days/day10.test.data")
$instructions = parse_data(content,"\n")

# remove from beginning: shift
# add to end: push

def generate_signals(instructions = $instructions)
  $signals = []
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
  end
  while !commands.empty?
    $signals.push(cursor)
    cursor = cursor + commands.shift
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

def part2
  signals = generate_signals
  image = Array.new(10){ Array.new(40){" "} }
  signals.each_index do |i|
    x = i%40
    if (x-signals[i]).abs <= 1
      image[i/40][x] = '#'
    end
  end
  image.each do |row|
    puts row.join
  end

end


generate_signals($instructions)
pp (1..$signals.length).zip($signals)
pp part1
part2