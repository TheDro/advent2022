load 'common.rb'
require 'json'
content = File.read("./days/day22.data")
# content = File.read("./days/day22.test.data")
$map, raw_directions = parse_data(content, "\n\n")
$directions = []
while raw_directions.length > 0 do
  if match = /^(R|L)/.match(raw_directions)
    $directions << raw_directions.slice!(0,match[1].size)
  elsif match = /^(\d+)/.match(raw_directions)
    $directions << raw_directions.slice!(0,match[1].size).to_i
  end
end
$map = $map.split("\n").map{ |row| row.split("") }.to_m
width = $map.map{ |row| row.length }.max
$map.each do |row|
  row.concat(Array.new(width - row.size) {" "})
end



def show(map: $map, cursor: nil)
  if cursor
    map = deep_dup(map)
    map[cursor.pos] = 'x'
  end

  puts map.to_a.map{|r| r.join('')}
end

def get_ranges()
  ranges = []
  ranges << $map.map do |row|
    inside = false
    result = []
    row.size.times do |i|
      if !inside && row[i] != " "
        inside = true
        result = [i,i]
      elsif inside && row[i] != " "
        result[1] = i
      end
    end
    result
  end

  ranges << $map.transpose.map do |row|
    inside = false
    result = []
    row.size.times do |i|
      if !inside && row[i] != " "
        inside = true
        result = [i,i]
      elsif inside && row[i] != " "
        result[1] = i
      end
    end
    result
  end
  ranges
end

def rotate(heading, direction)
  $headings ||= [[0,1], [-1,0], [0,-1], [1,0]]
  heading_index = $headings.find_index(heading)
  if direction == "L"
    heading_index = (heading_index + 1) % 4
  elsif direction == "R"
    heading_index = (heading_index - 1) % 4
  end
  $headings[heading_index]
end

Cursor = Struct.new(:pos, :heading)

def play(map: $map, directions: $directions)
  $ranges = get_ranges()

  cursor = Cursor.new([0,$ranges[0][0][0]], [0,1])
  directions.each do |direction|
    # show(cursor:)
    # binding.pry
    if direction.is_a?(Numeric)
      direction.times do |i|
        next_pos = get_next_pos(cursor)
        if map[next_pos] == "#"
          break
        else
          cursor.pos = next_pos
        end
      end
    else 
      cursor.heading = rotate(cursor.heading, direction)
    end
  end
  puts cursor
  cursor
end

def get_range(cursor)
  if cursor.heading[0].abs == 0
    return $ranges[0][cursor.pos[0]]
  else
    return $ranges[1][cursor.pos[1]]
  end
end

def get_next_pos(cursor)
  pos = cursor.pos
  heading = cursor.heading
  range = get_range(cursor)
  if heading[0].abs == 0
    return [pos[0], ((pos[1] + heading[1] - range[0]) % (range[1]-range[0]+1)) + range[0]]
  else
    return [((pos[0] + heading[0] - range[0]) % (range[1]-range[0]+1)) + range[0], pos[1]]
  end
end


def part1
  cursor = play
  heading_index = [[0,1], [1,0], [0,-1], [-1,0]]

  puts 1000*(cursor.pos[0]+1) + 4*(cursor.pos[1]+1) + heading_index.find_index(cursor.heading)
end