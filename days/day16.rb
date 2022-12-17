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


def explore(n, valve=$valves["AA"])
  tic
  $visited = {}

  moves = [Path.new(valve, released: 0, time: 0, previous: nil)]
  while !moves.empty? do
    # binding.pry

    path = moves.shift
    
    if !$visited[path.key] || $visited[path.key].released < path.released
      $visited[path.key] = path
      distances = path.valve.distances
      new_paths = distances.filter do |name, d|
        !path.visited.include?(name) && path.time+d < n
      end.map do |name, d|
        valve = $valves[name]
        time = path.time + d
        released =  path.released + (n-time)*valve.flow
        Path.new(valve, time: time, released: released, previous: path)
      end
      moves.concat(new_paths)
      # moves = moves.sort_by{|path| path.cost}
    end

  end
  toc
  $results = deep_dup($visited)
  # $results.values.each do |path|
  #   delta = n-path.time
  #   path.time = n
  #   path.cost += delta*path.flow
  # end
  $results = $results.values.sort_by{|path| -path.released}
  $results.first(20)
end



class Path
  attr_accessor :visited, :history, :valve, :released, :time, :previous, :history
  def initialize(valve, released:, time:, previous:)
    @history = []
    @valve = valve
    @released = released
    @time = time
    @previous = previous
    @visited = Set.new(previous&.visited)
    @visited.add(valve.name)
    @history = (previous&.history || []) + [valve.name]
  end

  # def fork(name)
  #   Path.new
  # end

  def key
    @time.to_s + ":" + @visited.to_a.sort.join(',')
  end

  def inspect
    "<Path:#{object_id} valve: #{valve.name} time: #{time} released: #{released} history: #{history.join(",")}>"
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