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


class Portal
  def initialize(range_a, range_b)
    @range_a = range_a
    @range_b = range_b
    generate_mapping
  end

  def generate_mapping
    @mapping_ab = {}
    @mapping_ba = {}
    @dir_a = (@range_a[1].to_m - @range_a[0]).map{|d| d == 0 ? 0 : d/d.abs}
    @dir_b = (@range_b[1].to_m - @range_b[0]).map{|d| d == 0 ? 0 : d/d.abs}
    enum_a = Vectors.range_between(@range_a[0], @dir_a, @range_a[1])
    enum_b = Vectors.range_between(@range_b[0], @dir_b, @range_b[1])
    enum_a.each do |a|
      b = enum_b.next
      @mapping_ab[a] = b
      @mapping_ba[b] = a
    end
    @rotations = 0
    rotated_dir = @dir_a
    4.times do |i|
      if rotated_dir == @dir_b
        @rotations = i
        break
      end
      rotated_dir = rotate(rotated_dir, "R")
    end
  end

  def travel(cursor)
    if (result_pos = @mapping_ab[cursor.pos])
      return nil if cursor.heading.zip(@dir_a).map{|a,b| (a*b).abs}.max > 0 # parallel
      result_heading = cursor.heading
      @rotations.times do 
        result_heading = rotate(result_heading, "R")
      end
      return Cursor.new(result_pos, result_heading)
    elsif (result_pos = @mapping_ba[cursor.pos])
      return nil if cursor.heading.zip(@dir_b).map{|a,b| (a*b).abs}.max > 0 # parallel
      result_heading = cursor.heading
      @rotations.times do 
        result_heading = rotate(result_heading, "L")
      end
      return Cursor.new(result_pos, result_heading)
    end
    return nil
  end

end

$portals = [
  Portal.new([[  1,  51], [  1, 100]],[[151,   1],[200,   1]]),
  Portal.new([[  1, 101], [  1, 150]],[[200,   1],[200,  50]]),
  Portal.new([[  1, 150], [ 50, 150]],[[150, 100],[101, 100]]),
  Portal.new([[ 50, 101], [ 50, 150]],[[ 51, 100],[100, 100]]),
  Portal.new([[  1,  51], [ 50,  51]],[[150,   1],[101,   1]]),
  Portal.new([[ 51,  51], [100,  51]],[[101,   1],[101,  50]]),
  Portal.new([[150,  51], [150, 100]],[[151,  50],[200,  50]]),
]


def show(map)
  # if cursor
  #   map = deep_dup(map)
  #   map[cursor.pos] = 'x'
  # end

  output = map.to_a.map{|r| r.join('')}.join("\n")
  File.write("whatever.log", output)
end




Cursor = Struct.new(:pos, :heading)

def play(map: $map, directions: $directions)
  map = wrap($map, 1)
  cursor = Cursor.new([1, 51], [0,1])

  n = 0
  directions.each do |direction|
    
    if direction.is_a?(Numeric)
      n = (n+1) % 10
      direction.times do |i|
        next_cursor = Cursor.new(get_next_pos(cursor), cursor.heading)
        if map[next_cursor.pos] == " "
          
          next_cursors = $portals.map do |portal|
            portal.travel(cursor)
          end.compact
          binding.pry if next_cursors.size != 1
          next_cursor = next_cursors.first
          # binding.pry
        end

        if map[next_cursor.pos] == "#"
          map[cursor.pos] = n
          break
        else
          map[next_cursor.pos] = n
          cursor = next_cursor
        end
      end
      puts direction
      if n == 0
        show(map)
        # binding.pry
        map = wrap($map, 1) 
      end

    else 
      cursor.heading = rotate(cursor.heading, direction)
    end
  end
  puts cursor
  cursor
end

def wrap(elves, layers=1)
  result = Matrix.same_values(elves.size.to_m + ([2,2].to_m*layers), " ")
  nx,ny = elves.size
  nx.times do |i|
    ny.times do |j|
      result[i+layers][j+layers] = elves[i][j]
    end
  end
  result
end


def get_next_pos(cursor)
  pos = cursor.pos
  heading = cursor.heading
  pos.zip(heading).map do |a,b| a+b end
end

#  180095 is too big
def part2
  cursor = play
  heading_index = [[0,1], [1,0], [0,-1], [-1,0]]
  binding.pry
  puts 1000*(cursor.pos[0]) + 4*(cursor.pos[1]) + heading_index.find_index(cursor.heading)
end

