load 'common.rb'
require 'json'
content = File.read("./days/day21.data")
# content = File.read("./days/day21.test.data")
$data = parse_data(content, "\n")

$monkeys = {}
$data.each do |row|
  match = /(\w+): (\w+) (.) (\w+)/.match(row)
  if match
    $monkeys[match[1]] = [match[2], match[3], match[4]]
  else
    key, value = row.split(": ")
    $monkeys[key] = value.to_i
  end
end

def part1

  get_value($monkeys, "root")

end


def get_value(monkeys, key)
  return monkeys[key] if monkeys[key].is_a?(Numeric)

  monkey = monkeys[key]
  if monkey[1] == "+"
    get_value(monkeys, monkey[0]) + get_value(monkeys, monkey[2])
  elsif monkey[1] == "-"
    get_value(monkeys, monkey[0]) - get_value(monkeys, monkey[2])
  elsif monkey[1] == "*"
    get_value(monkeys, monkey[0]) * get_value(monkeys, monkey[2])
  elsif monkey[1] == "/"
    get_value(monkeys, monkey[0]).to_f / get_value(monkeys, monkey[2])
  end

end


$keys = [$monkeys["root"][0], $monkeys["root"][2]]

# 3876907167498 is too high
def part2(offset=30000000000000)
  monkeys = deep_dup($monkeys)
  low = 0
  high = offset
  100.times do |i|
    low_result = get_diff(monkeys, low)
    high_result = get_diff(monkeys, high)
    mid = (high + low)/2
    mid_result = get_diff(monkeys, mid)

    puts "#{low}, #{mid}, #{high}: #{low_result}, #{mid_result}, #{high_result}"
    if mid_result == 0
      return mid
    elsif low_result * mid_result < 0
      high = mid
    elsif high_result * mid_result < 0
      low = mid
    else
      binding.pry
    end

  end
end

def get_diff(monkeys, value, keys=$keys)
  monkeys["humn"] = value
  diff = get_value(monkeys, keys[0]) - get_value(monkeys, keys[1])
end
