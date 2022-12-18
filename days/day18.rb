load 'common.rb'
require 'json'
content = File.read("./days/day18.data")
# content = File.read("./days/day18.test.data")
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


def group(pieces=$pieces)
  $chunks = []

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
  

  piece_set = Set.new($pieces)
  moves = [boundaries.map(&:min)]
  outside_set = Set.new
  while !moves.empty? do
    # binding.pry
    pos = moves.shift
    if piece_set.include?(pos) || outside_set.include?(pos)
      next
    end
    outside_set.add(pos)

    all_directions.each do |dir|
      new_pos = (pos.to_m + dir).to_a
      if within(new_pos, boundaries)
        moves.push(new_pos)
      end
    end
  end
  $outside_set = outside_set

  $new_pieces = []
  Range.new(*boundaries[0]).each do |i|
    Range.new(*boundaries[1]).each do |j|
      Range.new(*boundaries[2]).each do |k|
        $new_pieces.push([i,j,k]) if !outside_set.include?([i,j,k])
      end
    end
  end
  $new_pieces
end

def within(pos, bounds) 
  pos.size.times do |i|
    if pos[i] < bounds[i][0] || pos[i] > bounds[i][1]
      return false
    end
  end
  return true
end

def part1
  puts group($pieces)
end

def part2
  new_pieces = fill
  puts group(new_pieces)
end


