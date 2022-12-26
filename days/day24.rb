load 'common.rb'
require 'json'
content = File.read("./days/day24.data")
# content = File.read("./days/day24.test.data")
$data = parse_data(content, "\n", "")


class Blizzard
  @@direction_index = {
    "v" => 0,
    ">" => 1,
    "^" => 2,
    "<" => 3
  }
  @@directions = [[1,0],[0,1],[-1,0],[0,-1]].map(&:to_m)

  attr_accessor :initial_state, :nx, :ny, :period, :winds, :states
  def initialize(state)
    @initial_state = state.to_m
    @nx, @ny = state.to_m.size.to_m - [2,2]
    @period = @nx.lcm(@ny)
    @winds = generate_winds(state)
    @states = {}
  end

  def get_state(time)
    time = time % @period
    if !@states[time]
      @states[time] = Matrix.zeros([@nx+2,@ny+2])
      state = @states[time]
      (@nx+2).times do |i|
        (@ny+2).times do |j|
          if @initial_state[i][j] == "#"
            state[[i,j]] = 5
          end
        end
      end
      @winds.each_with_index do |coords, w|
        direction = @@directions[w]
        offset = direction*time
        coords.each do |coord|
          pos = offset+coord
          pos[0] = (pos[0] % @nx)
          pos[1] = (pos[1] % @ny)
          state[pos+[1,1]] += 1
        end
      end
    end
    @states[time]
  end

  def get_spot(pos,time)
    get_state(time)[pos]
  end

  def generate_winds(state)
    winds = Array.new(4){[]}
    state.each_with_index do |row, i|
      row.each_with_index do |cell, j|
        wind_index = @@direction_index[cell]
        winds[wind_index] << [i-1,j-1] if wind_index
      end
    end
    winds
  end
    
end

def show(time=0)
  puts $blizzard.get_state(time).map{|row| row.map{ |e|
    {5 => "#", 0 => " "}[e] || e
  }.join()}.join("\n")
end



class Path
  attr_accessor :pos, :time
  def initialize(pos, time)
    @pos = pos
    @time = time
  end

  def key
    "#{time % $blizzard.period}:#{pos.join(",")}"
  end
end


def run()
  directions = [[0,0],[1,0],[0,1],[-1,0],[0,-1]].map(&:to_m)
  goal = [$blizzard.nx+1, $blizzard.ny]
  moves = [Path.new([0,1].to_m, 0)]
  move_set = Set.new()
  move_set << moves[0].key
  $result = nil
  $visited = {}
  iterations = 0

  $farthest = 0
  while !moves.empty?
    # binding.pry
    path = moves.shift

    iterations += 1
    if (iterations % 10000 == 0)
      puts "#{iterations} iterations: #{moves.size} moves left. Path: #{path.time} #{path.pos}. Fartest: #{$farthest}"
      binding.pry
    end

    if ($blizzard.get_spot(path.pos, path.time) > 0)
      next
    end
    if $visited[path.key] && $visited[path.key].time < path.time
      next
    end
    if path.pos.sum < $farthest - 4
      next
    end
    
    $visited[path.key] = path
    $farthest = [path.pos.sum, $farthest].max
    if path.pos == goal
      $result = path
      break
    end
    time = path.time+1
    directions.each_with_index do |direction, i|
      pos = direction + path.pos
      # binding.pry
      next if pos.min < 0
      next if $blizzard.get_spot(pos, time) > 0
      new_path = Path.new(pos.to_a, time)
      next if move_set.include?(new_path.key)
      move_set << new_path.key
      moves << new_path
    end
  end
  farthest = $visited.sort_by{|k,path| -path.time}
  binding.pry
  puts "complete at t=#{$result.time}"
end

$blizzard = Blizzard.new($data)
run
