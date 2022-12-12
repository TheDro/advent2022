load 'common.rb'
content = File.read("./days/day12.data")
# content = File.read("./days/day12.test.data")
$height_data = parse_data(content,"\n", "")
$start = nil
$end = nil
$height = Matrix.zeros($height_data.to_m.size)
$height_data.to_m.each_index do |i,j|
  if $height_data[i][j] == "S"
    $start = [i,j]
    $height[i][j] = 0
  elsif $height_data[i][j] == "E"
    $end = [i,j]
    $height[i][j] = 26
  else
    $height[i][j] = $height_data[i][j].ord - "a".ord + 1
  end
end

class Node
  attr_accessor :cost, :height, :pos

  def initialize(cost:, height:, pos:)
    @cost = cost
    @height = height
    @pos = pos
  end
end



def part1
  start = $start.dup
  $nodes = Array.new($height.size[0]) {Array.new($height.size[1]){nil}}.to_m
  bounds = $nodes.size.to_m-[1,1]
  moves = [Node.new(cost: 0, height: $height[start], pos: start)]
  $nodes[start] = moves[0]
  while moves.size > 0
    cursor = moves.shift
    pos = cursor.pos
    [[0,1],[0,-1],[1,0],[-1,0]].each do |dir|
      next_pos = cursor.pos.to_m + dir
      # This logic won't work if there's a shorter path that takes longer to get to
      # the cost is always 1 in this scenario so it won't happen but should be fixed later
      if within_bounds?(next_pos, bounds) && $nodes[next_pos].nil? && ($height[next_pos]-cursor.height) <= 1
        next_node = Node.new(cost: cursor.cost+1, height: $height[next_pos], pos: next_pos)
        moves.push(next_node)
        $nodes[next_pos] = next_node
      end
    end
    moves = moves.sort_by(&:cost)
  end
  $nodes[$end].cost
end


def part2
  start = $end.dup
  $nodes = Array.new($height.size[0]) {Array.new($height.size[1]){nil}}.to_m
  bounds = $nodes.size.to_m-[1,1]
  moves = [Node.new(cost: 0, height: $height[start], pos: start)]
  $nodes[start] = moves[0]
  while moves.size > 0
    cursor = moves.shift
    pos = cursor.pos
    [[0,1],[0,-1],[1,0],[-1,0]].each do |dir|
      next_pos = cursor.pos.to_m + dir
      # This logic won't work if there's a shorter path that takes longer to get to
      # the cost is always 1 in this scenario so it won't happen but should be fixed later
      if within_bounds?(next_pos, bounds) && $nodes[next_pos].nil? && ($height[next_pos]-cursor.height) >= -1
        next_node = Node.new(cost: cursor.cost+1, height: $height[next_pos], pos: next_pos)
        moves.push(next_node)
        $nodes[next_pos] = next_node
      end
    end
    moves = moves.sort_by(&:cost)
  end
  potential_starts = []
  $nodes.each do |row|
    row.each do |node|
      potential_starts << node if node&.height == 1
    end
  end
  potential_starts = potential_starts.sort_by(&:cost)
  binding.pry
end


def within_bounds?(pos, bounds)
  return false if pos.min < 0
  return false if (pos.zip(bounds).map{|a,b| a-b}).max > 0
  true
end

# puts part1 # 506 is too high
part2
node_img = $nodes.map do |row|
  row.map do |node|
    (node&.cost || 0) % 100
  end
end
imagesc(node_img, 4)
