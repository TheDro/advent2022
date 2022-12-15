load 'common.rb'
require 'json'
content = File.read("./days/day15.data")
# content = File.read("./days/day15.test.data")
$data = parse_data(content,"\n")
$beacons = []
$sensors = $data.map do |row|
  match = /Sensor at x=([-\d]+), y=([-\d]+): closest beacon is at x=([-\d]+), y=([-\d]+)/.match(row)
  $beacons.push([match[4].to_i, match[3].to_i])
  vectors = [[match[2].to_i, match[1].to_i],[match[4].to_i, match[3].to_i]]
  radius = (vectors[0][0]-vectors[1][0]).abs + (vectors[0][1]-vectors[1][1]).abs
  [vectors[0][0], vectors[0][1], radius]
end
$beacons = $beacons.uniq

def count_row(x, sensors = $sensors)
  ranges = get_ranges(x, sensors)
  coverage = get_coverage(ranges)
  binding.pry
  coverage - $beacons.filter{|b| b[0] == x}.size
end

def get_ranges(x, sensors = $sensors)
  result = []
  sensors.each do |sensor|
    distance = (sensor[0] - x).abs
    radius = sensor[2]-distance
    if radius >= 0
      result.push([sensor[1]-radius, sensor[1]+radius])
    else
      result.push(nil)
    end
  end
  pp result
  result.compact
end

def get_coverage(orig_ranges)
  ranges = deep_dup(orig_ranges)
  result = []
  ranges.size.times do |i|
    break if i >= ranges.size
    next if ranges[i].nil?
    j = 0
    100000.times do
      if j == ranges.size
        break
      end
      if ranges[j].nil? || i == j
        j += 1
        next
      end
      if overlap?(ranges[i], ranges[j])
        puts "overlap: #{ranges[i]} #{ranges[j]}"
        ranges[i] = [ [ranges[i][0], ranges[j][0]].min , [ranges[i][1], ranges[j][1]].max ]
        ranges[j] = nil
        puts "result: #{ranges[i]}"
        j = 0
        next
      end
      j += 1
    end
  end
  binding.pry
  separate_ranges = ranges.compact

  separate_ranges.reduce(0) do |sum, range|
    sum + (range[1]-range[0]+1)
  end
end

def overlap?(a, b)
  (a[0] <= b[0] && b[0] <= a[1]) || (a[0] <= b[1] && b[1] <= a[1])
end


# part1
# puts count_row(10)
puts count_row(2000000) # 6217513 is too large