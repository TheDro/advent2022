require 'pry'
load 'common.rb'
# load './days/day08.rb'
content = File.read("./days/day08.data")
# content = File.read("./days/day08.test.data")


def update_visibility(start, dir1, dir2)
  start = Matrix.new(start)
  Vectors.range([0,0],dir1).each do |i|
    break if $trees[i].nil?
    i = start+i
    max_height = -1
    Vectors.range([0,0],dir2).each do |j|
      pos = i+j
      break if $trees[pos].nil?
      if $trees[pos] > max_height
        max_height = $trees[pos]
        $visible[pos] = 1
      end
    end
  end
end



def part1
  $visible = Matrix.zeros($trees.size)
  nx, ny = $trees.size
  update_visibility([0,0],[1,0],[0,1])
  update_visibility([0,0],[0,1],[1,0])
  update_visibility([nx-1,ny-1],[-1,0],[0,-1])
  update_visibility([nx-1,ny-1],[0,-1],[-1,0])

  puts "part1: #{$visible.sum{|row| row.sum} }"
end

def visible_trees(pos, dir)
  pos = Matrix.new(pos)
  height = $trees[pos]
  total = 0
  Vectors.range((pos+dir).to_a,dir).each do |x|
    break if $trees[x].nil? || x.min < 0
    if $trees[x] >= height
      total += 1
      break
    else
      total +=1
    end
  end
  total
end


def part2
  scores = Matrix.zeros($trees.size)
  nx, ny = $trees.size
  nx.times do |i|
    ny.times do |j|
      scores[[i,j]] = 
        visible_trees([i,j], [0,1]) *
        visible_trees([i,j], [1,0]) *
        visible_trees([i,j], [-1,0]) *
        visible_trees([i,j], [0,-1])
    end
  end
  max_score = scores.map(&:max).max
  puts "part2: #{max_score}"
  scores
end


$trees = parse_data(content, "\n", "").map do |row|
  row.map(&:to_i)
end
$trees = Matrix.new($trees)

# part1
# part2