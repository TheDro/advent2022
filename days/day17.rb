load 'common.rb'
require 'json'
content = File.read("./days/day17.data")
# content = File.read("./days/day17.test.data")
$directions = parse_data(content, "")
DIRS = {"<" => [0,-1], ">" => [0,1]}
$directions = $directions.map do |direction|
  DIRS[direction]
end

DOWN = [-1,0]

class Piece
  attr_accessor :area, :coords, :height
  def initialize(area)
    @area = area.to_m
    @coords = get_coords(@area)
    @height = area.size
  end

  def get_coords(area)
    coords = []
    area.array.size.times do |i|
      row = area[i]
      row.size.times do |j|
        coords << [i,j] if area[i][j] == 1
      end
    end
    coords
  end
end

$pieces = [
  Piece.new([[1,1,1,1]]),
  Piece.new([[0,1,0],[1,1,1],[0,1,0]]),
  Piece.new([[1,1,1],[0,0,1],[0,0,1]]),
  Piece.new([[1],[1],[1],[1]]),
  Piece.new([[1,1],[1,1]])
]


class Stat
  def initialize
    @delta_n = {}
    @delta_height = {}
    @last_n = {}
    @last_height = {}
  end

  # key: direction,piece
  def add(direction_index:, piece_index:, n:, height:)
    return if piece_index != 0
    key = [direction_index, piece_index].join(",")

    @last_n[key] ||= 0
    last_n = @last_n[key]
    @delta_n[key] ||= []
    @delta_n[key] << n-last_n
    @last_n[key] = n

    @last_height[key] ||= 0
    last_height = @last_height[key]
    @delta_height[key] ||= []
    @delta_height[key] << height-last_height
    @last_height[key] = height

    if @delta_height[key].size > 2 && @delta_height[key][-1] == @delta_height[key][-2]
      # binding.pry
      return [@delta_n[key][-1], @delta_height[key][-1]]
    else
      return nil
    end

  end
end



def play(n=1)
  $cave = Matrix.zeros([10*$directions.length,7])
  $i_dir = 0
  $top_free_row = 0
  $stats = Stat.new()

  i = 0
  skip_pattern = false
  height_offset = 0
  while i < n do
    piece_index = i % $pieces.size
    pattern = $stats.add(direction_index: $i_dir, piece_index: piece_index, n: i, height: $top_free_row) if !skip_pattern
    if pattern
      puts pattern.join(",")
      skip_pattern = true
      chunks = ((n-i)/pattern[0]).floor-1
      n_offset = chunks*pattern[0]
      height_offset = chunks*pattern[1]
      i += n_offset
      # binding.pry
      pattern = nil
    end
    # $stats.push([$top_free_row, $i_dir, i % $pieces.size])
    piece = $pieces[piece_index]
    drop_piece(piece)
    i += 1
  end
  $top_free_row + height_offset
end

def drop_piece(piece)
  corner = Matrix.new([$top_free_row+3,2])

  loop do
    sideways = $directions[$i_dir]
    $i_dir = ($i_dir+1) % $directions.size
    corner.add!(sideways)
    if overlap?(piece, corner)
      corner.subtract!(sideways)
    end

    corner.add!(DOWN)
    if overlap?(piece, corner)
      corner.subtract!(DOWN)
      piece.coords.each do |delta|
        coord = corner + delta
        $cave[coord] = 1
      end
      $top_free_row = [$top_free_row, corner[0]+piece.height].max 
      break
    end

  end
end


def overlap?(piece, corner)
  piece.coords.each do |delta|
    coord = corner + delta
    if coord[1] < 0 || coord[1] >= $cave[0].size || coord[0] < 0 || $cave[coord] == 1
      return true
    end
  end
  return false
end

def show
  puts $cave.map{|row| row.map{|a| a==0 ? "." : "#"}.join}.reverse.join("\n")
end


