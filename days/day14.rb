load 'common.rb'
require 'json'
content = File.read("./days/day14.data")
# content = File.read("./days/day14.test.data")
$data = parse_data(content,"\n", " -> ")
$walls = $data.map do |row|
  result = []
  (1..row.size-1).each do |i|
    result.push([row[i-1].split(',').map(&:to_i).reverse, row[i].split(',').map(&:to_i).reverse])
  end
  result
end.flatten(1)

def range1(start, stop)
  delta = [stop[0] <=> start[0], stop[1] <=> start[1]]
  Enumerator.new do |y|
    cursor = start
    loop do
      y << cursor
      break if cursor[0] == stop[0] && cursor[1] == stop[1]
      cursor = [cursor[0] + delta[0], cursor[1] + delta[1]]
    end
  end
end

def generate_sandbox(walls)
  max_x = 0
  min_y = 1000
  max_y = 0

  walls.each do |wall|
    max_x = [max_x, wall[0][0], wall[1][0]].max
    min_y = [min_y, wall[0][1], wall[1][1]].min
    max_y = [max_y, wall[0][1], wall[1][1]].max
  end
  min_y = min_y-1
  max_y = max_y+1
  max_x = max_x+1

  sand = Matrix.zeros([max_x + 1, max_y - min_y + 1])
  
  new_walls = walls.map do |wall|
    wall.map do |point|
      [point[0], point[1]-min_y]
    end
  end

  new_walls.each do |wall|
    range1(wall[0], wall[1]).each do |pos|
      sand[pos] = 1
    end
  end


  [[[0, max_x], [min_y, max_y]], sand]
end

def part1(sand=$sand, source=$source, n: 1)
  sand = sand.dup
  limits = sand.size.to_m-[1,1]
  n.times do |i|
    cursor = Matrix.new(source.dup)
    1000.times do
      if sand[cursor + [1,0]] == 0
        cursor += [1,0]
      elsif sand[cursor + [1,-1]] == 0
        cursor += [1,-1]
      elsif sand[cursor + [1,1]] == 0
        cursor += [1,1]
      else
        sand[cursor] = 2
        break
      end
      if cursor[0] == limits[0] || cursor[1] == 0 || cursor[1] == limits[1]
        imagesc(sand)
        return i
      end
    end
  end
  imagesc(sand)
end

# def part2(sand=$sand, source=$source, n: 1)





$range, $sand = generate_sandbox($walls)
$source = [0, 500-$range[1][0]]
part1


