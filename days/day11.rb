load 'common.rb'
content = File.read("./days/day11.data")
# content = File.read("./days/day11.test.data")
$monkey_data = parse_data(content,"\n\n")


class Monkey

  attr_reader :divisible

  def initialize(data)
    parse(data)
  end

  def parse(data)
    lines = data.split("\n")
    @number = lines[0].match(/Monkey ([0-9])/)[1].to_i
    @items = lines[1].match(/items: ([0-9, ]+)/)[1].split(', ').map(&:to_i)
    lines[2].match(/new = old ([*+]) (\w+)/).tap do |match|
      @operation = [match[1], match[2]]
    end
    @divisible = lines[3].match(/divisible by (\d+)/)[1].to_i
    @targets = [
      lines[4].match(/monkey (\d)/)[1].to_i,
      lines[5].match(/monkey (\d)/)[1].to_i
    ]
  end

  def run
    @items.size.times do |i|
      $inspections[@number] += 1
      item = @items.shift
      new_item = apply_operation(item)
      if new_item % @divisible == 0
        $monkeys[@targets[0]].add(new_item)
      else
        $monkeys[@targets[1]].add(new_item)
      end
    end
  end

  def add(item)
    @items.push(item)
  end

  def apply_operation(item)
    result = item
    if @operation[1] == "old"
      argument = item
    else
      argument = @operation[1].to_i
    end
    if @operation[0] == "+"
      result += argument
    elsif @operation[0] == "*"
      result *= argument
    end
    # (result/3).floor
    result % $prime_factor
  end

end

def reset
  puts "reset monkeys"
  $inspections = Array.new($monkey_data.size){0}
  $prime_factor = 1
  $monkeys = $monkey_data.map do |data|
    monkey = Monkey.new(data)
    $prime_factor *= monkey.divisible
    monkey
  end
end

def run_rounds(n=1)
  n.times do
    $monkeys.each do |monkey|
      monkey.run
    end
  end
  puts $inspections.join(' ')
end

reset()

# def part1
#   reset()
#   run_rounds(20)
#   result = $inspections.sort[-2..].reduce(1) { |prod, x| x*prod }
#   puts "part1: #{result}"
# end

def part2
  reset()
  run_rounds(10000)
  result = $inspections.sort[-2..].reduce(1) { |prod, x| x*prod }
  puts "part2: #{result}"
end

