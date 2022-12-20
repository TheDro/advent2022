load 'common.rb'
require 'json'
content = File.read("./days/day16.data")
# content = File.read("./days/day16.test.data")
$data = parse_data(content,"\n")

Valve = Struct.new(:name, :flow, :connections, :distances)


def update_distances(starting_valve)
  distances = {}
  moves = [[starting_valve.name, 0]]
  while !moves.empty? do
    move = moves.shift
    name, d = move
    if !distances[name]
      distances[name] = d
      valve = $valves[name]
      moves.concat(valve.connections.map do |connection|
        [connection, d+1]
      end)
      # moves = moves.sort_by{|move| move[1]}
    end
  end
  distances.delete(starting_valve.name)
  distances.keys.each do |key|
    distances[key] = distances[key] + 1
  end
  distances = distances.filter do |name, d|
    $valves[name].flow > 0
  end

  starting_valve.distances = distances
end

MiniPath = Struct.new(:released)
$minimum_released = 1500
$longest_trip = 4

def explore(n, valve=$valves["AA"])
  tic
  $visited = {}

  moves = [Path.new([valve, valve], released: 0, times: [0,0], previous: nil)]
  iteration = 0
  while !moves.empty? do
    iteration += 1
    if iteration % 10000 == 0
      puts "Iteration #{iteration}: #{moves.size} moves left"
    end
    # binding.pry
    path = moves.shift
    
    if !$visited[path.key] || $visited[path.key].released < path.released
      if path.released > $minimum_released
        $visited[path.key] = path
      else
        $visited[path.key] = MiniPath.new(path.released)
      end

      if path.times[0] <= path.times[1]
        distances = path.valves[0].distances.filter do |name, d|
          !path.visited.include?(name) && path.times[0]+d < n && d <= $longest_trip
        end
        
        if distances.any?
          new_paths = get_new_paths(0, n, path, distances)
          moves.concat(new_paths)
        else
          distances = path.valves[1].distances.filter do |name, d|
            !path.visited.include?(name) && path.times[1]+d < n && d <= $longest_trip
          end
          new_paths = get_new_paths(1, n, path, distances)
          moves.concat(new_paths)
        end
      else
        distances = path.valves[1].distances.filter do |name, d|
          !path.visited.include?(name) && path.times[1]+d < n && d <= $longest_trip
        end
        new_paths = get_new_paths(1, n, path, distances)
        moves.concat(new_paths)
      end

    end

  end
  toc
  $results = deep_dup($visited.filter{|key, path| path.released > $minimum_released})
  # $results.values.each do |path|
  #   delta = n-path.time
  #   path.time = n
  #   path.cost += delta*path.flow
  # end
  $results = $results.values.sort_by{|path| -path.released}
  $results.first(20)
end


def get_new_paths(valve_index, n, path, distances)
  distances.map do |name, d|
    next_valve = $valves[name]
    next_time = path.times[valve_index] + d
    released = path.released + (n-next_time)*next_valve.flow

    valves = valve_index == 0 ? [next_valve, path.valves[1]] : [path.valves[0], next_valve]
    times = valve_index == 0 ? [next_time, path.times[1]] : [path.times[0], next_time]
    Path.new(valves, released: released, times: times, previous: path)
  end
end



class Path
  attr_accessor :visited, :histories, :valves, :released, :times, :previous
  def initialize(valves, released:, times:, previous:)
    @valves = valves
    @released = released
    @times = times
    @previous = previous
    @visited = Set.new(previous&.visited)
    @histories = (deep_dup(previous&.histories) || [[],[]])
    if @histories[0][-1] != valves[0].name
      @histories[0].concat([valves[0].name])
      @visited.add(valves[0].name)
    end
    if @histories[1][-1] != valves[1].name
      @histories[1].concat([valves[1].name])
      @visited.add(valves[1].name)
    end
  end


  def key
    @times.to_s + ":" + @visited.to_a.sort.join(',')
  end

  def inspect
    h = histories.map{ |h| h.join(',') }.join(';')
    "<Path:#{object_id} valves: #{valves.map(&:name).join(';')} times: #{times.to_s} released: #{released} histories: #{h}>"
  end

end

$valve_array = $data.map do |row|
  match = /Valve (\w+) has flow rate=(\d+).*valves? (.*)/.match(row)
  name = match[1]
  flow = match[2].to_i
  connections = match[3].split(", ")
  Valve.new(name, flow, connections)
end

$valves = {}
$valve_array.each do |valve|
  $valves[valve.name] = valve
end

$valves.values.each do |valve|
  update_distances(valve)
end

explore(5)

def part1
  result = explore(30)[0]
  puts "#{result.released}" # 1786 is too low
end

# part1