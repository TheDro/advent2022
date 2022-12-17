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


def play(n=1)
  $cave = Matrix.zeros([30+2*n,7])
  $i_dir = 0
  $top_free_row = 0
  n.times do |i|
    piece = $pieces[i % $pieces.size]
    drop_piece(piece)
  end
  $top_free_row
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

def part1
  puts play(2022)
end

part1