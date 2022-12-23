load 'common.rb'
require 'json'
content = File.read("./days/day23.data")
# content = File.read("./days/day23.test.data")
$elves = parse_data(content, "\n", "").map do |row|
  row.map do |e|
    e == "#" ? 1 : 0
  end
end.to_m

$directions = [
  [[-1,0],[-1,-1],[-1,1]],
  [[1,0],[1,-1],[1,1]],
  [[0,-1],[-1,-1],[1,-1]],
  [[0,1],[-1,1],[1,1]]
]

def show(elves = $elves)
  output = elves.map{|row| row.map do |e|
    e == 0 ? "." : e
  end.join(" ")}.join("\n")
  File.write("whatever.log", output)
end


def wrap(elves, layers=1)
  result = Matrix.zeros(elves.size.to_m + ([2,2].to_m*layers))
  nx,ny = elves.size
  nx.times do |i|
    ny.times do |j|
      result[i+layers][j+layers] = elves[i][j]
    end
  end
  result
end

def play(n=1)
  elves = wrap($elves, n)
  show(elves)
  n.times do |i|
    directions = [0,1,2,3].map do |e|
      $directions[(e+i) % 4]
    end
    proposals = get_proposals(elves, directions)
    new_elves = get_new_elves(elves, directions, proposals)
    show(new_elves)
    # binding.pry
    elves = new_elves
  end
  elves
end


def get_proposals(elves, directions)
  proposals = Matrix.zeros(elves.size)
  elves.each_with_index do |row, i|
    row.each_with_index do |e, j|
      
      if e == 1
        # binding.pry
        new_pos = get_move([i,j], elves, directions)
        proposals[new_pos] += 1 if new_pos
      end

    end
  end
  proposals
end


def get_move(pos, elves, directions)
  pos = pos.to_m

  total = 0
  (-1..1).each do |i|
    (-1..1).each do |j|
      total += 1 if elves[pos + [i,j]] == 1
    end
  end
  if total == 1
    return pos
  end

  directions.each do |angles|
    in_the_way = elves[pos + angles[0]] +
      elves[pos + angles[1]] +
      elves[pos + angles[2]] 
    if in_the_way == 0
      $any_moves = true
      return pos + angles[0]
    end
  end
  pos
end

def get_new_elves(elves, directions, proposals)
  new_elves = Matrix.zeros(elves.size)
  elves.each_with_index do |row, i|
    row.each_with_index do |e, j|
      pos = [i,j]
      if e == 1
        new_pos = get_move(pos, elves, directions)
        if proposals[new_pos] < 2
          new_elves[new_pos] = 1
        else
          new_elves[pos] = 1
        end
      end
    end
  end
  new_elves
end

def part1
  elves = play(10)
  elf_x = []
  elf_y = []
  elves.each_with_index do |row, i|
    row.each_with_index do |e, j|
      if e == 1
        elf_x << i
        elf_y << j
      end
    end
  end
  puts "part1: #{ (elf_x.max - elf_x.min + 1) * (elf_y.max - elf_y.min + 1) - elf_x.size }"
end

def play2()
  elves = wrap($elves, 60)
  1000.times do |i|
    directions = [0,1,2,3].map do |e|
      $directions[(e+i) % 4]
    end
    $any_moves = false
    proposals = get_proposals(elves, directions)
    new_elves = get_new_elves(elves, directions, proposals)
    
    puts i
    if i % 10 == 0
      diff = new_elves - elves
      imagesc(diff, 1)
      imagesc(new_elves, 2)
    end
    if !$any_moves
      return i
    end
    elves = new_elves
  end
  elves
end


def part2
  puts play2()+1
end
