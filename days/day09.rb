require 'pry'
load 'common.rb'
content = File.read("./days/day09.data")
# content = File.read("./days/day09.test.data")
$moves = parse_data(content,"\n"," ")

$dirs = {
  "U" => [0,1],
  "D" => [0,-1],
  "L" => [-1,0],
  "R" => [1,0],
}

def distance(a,b)
  return a.zip(b).map{ |a,b| (a-b).abs }.max
end

def part1
  $head = Matrix.new([0,0])
  $tail = Matrix.new([0,0])
  $visited = Set.new
  $visited.add($tail.join(','))

  $moves.each do |dir, n|
    dir = $dirs[dir]
    n.to_i.times do |i|
      $head.add!(dir)
      if distance($head, $tail) > 1
        $tail = $head-dir
        $visited.add($tail.join(','))
      end
    end
  end
  $visited.size
end

def part2
  n_knots = 10
  $knots = Array.new(n_knots){Matrix.new([0,0])}
  $visited = Set.new
  $visited.add($knots[0].join(','))

  $moves.each do |dir, n|
    dir = $dirs[dir]
    n.to_i.times do |i|
      previous_position = $knots[0]
      $knots[0] = $knots[0] + dir
      (1..n_knots-1).each do |i_knot|
        next_move = get_next_move($knots[i_knot-1], $knots[i_knot])
        $knots[i_knot] = $knots[i_knot] + next_move
        $visited.add($knots[i_knot].join(',')) if i_knot == n_knots-1
      end
    end
  end
  $visited.size
end

def get_next_move(head,tail)
  if distance(head, tail) > 1
    Matrix.new((head-tail).map{|d| d/[d.abs,1].max})
  else
    Matrix.new([0,0])
  end
end

puts part1
puts part2