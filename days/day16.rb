load 'common.rb'
require 'json'
content = File.read("./days/day16.data")
content = File.read("./days/day16.test.data")
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
    end
  end
  distances.delete(starting_valve.name)
  distances.keys.each do |key|
    distances[key] = distances[key] + 1
  end
  starting_valve.distances = distances
end


def explore(n, valve=$valves["AA"])
  $visited = {}
  $starting_flow = $valves.values.reduce(0) do |total, valve|
    total + valve.flow
  end

  moves = [Path.new(valve, cost: 0, time: 0, previous: nil)]

  while !moves.empty? do
    # binding.pry
    path = moves.shift
    if path.time > n
      next
    end
    if !$visited[path.key] || $visited[path.key].cost > path.cost
      $visited[path.key] = path
      distances = path.valve.distances
      new_paths = distances.map do |name, d|
        cost = path.cost + d*path.flow
        next_flow = path.flow - $valves[name].flow
        time = path.time + d
        Path.new($valves[name], time: time, cost: cost, flow: next_flow, previous: path)
      end
      moves.concat(new_paths)
      moves = moves.sort_by{|path| path.cost}
    end

  end

  $results = deep_dup($visited)
  $results.values.each do |path|
    delta = n-path.time
    path.time = n
    path.cost += delta*path.flow
  end
  $results = $results.values.sort_by{|path| path.cost}
  $results.first(40)
end



class Path
  attr_accessor :visited, :history, :flow, :valve, :cost, :time, :previous, :history
  def initialize(valve, cost:, time:, previous:, flow: $starting_flow)
    @history = []
    @flow = flow
    @valve = valve
    @cost = cost
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
    @visited.to_a.sort.join(',')
  end

  def inspect
    "<Path:#{object_id} valve: #{valve.name} time: #{time} cost: #{cost} flow: #{flow} history: #{history.join(",")}>"
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

explore(3)

