load 'common.rb'
require 'json'
content = File.read("./days/day18.data")
content = File.read("./days/day18.test.data")
$pieces = parse_data(content, "\n", ",").map{|row| row.map{|v| v.to_i}}


class Chunk

  def initialize()
    @pieces = []
  end

  def add(piece)
    @pieces << piece
  end

  def get_area
    piece_set = Set.new(@pieces)
    areas = []
    moves = deep_dup(@pieces)
    moves.each do |piece|
      all_directions.each do |dir|
        pos = (piece.to_m + dir).to_a
        if !piece_set.include?(pos)
          areas.push(pos)
        end
      end
    end
    return areas.size
  end


end

def all_directions
  [[-1,0,0],[1,0,0],[0,-1,0],[0,1,0],[0,0,-1],[0,0,1]]
end


def group
  $chunks = []
  pieces = deep_dup($pieces)

  piece_set = Set.new(pieces)
  while !piece_set.empty? do
    chunk = Chunk.new
    $chunks.push(chunk)

    piece = piece_set.first
    moves = [piece]
    # binding.pry

    while !moves.empty? do
      # binding.pry
      piece = moves.shift
      if piece_set.include?(piece)
        chunk.add(piece)
        piece_set.delete(piece)
        # binding.pry
        all_directions.each do |dir|
          moves.push((piece.to_m + dir).to_a)
        end
      end
    end

  end
  total_area = 0
  $chunks.each do |chunk|
    total_area += chunk.get_area
  end
  total_area
end


def fill
  boundaries = []
  3.times do |i|
    values = $pieces.map do |piece|
      piece[i]
    end
    boundaries.push([values.min-1, values.max+1])
  end
  binding.pry
end




