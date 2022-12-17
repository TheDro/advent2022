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
  $starting_flow = $valves.values.reduce(0) do |total, valve|
    total + valve.flow
  end

  moves = [Path.new(valve, cost: 0, time: 0, previous: nil)]
  largest_time = 0
  lowest_total_cost = $starting_flow*n
  puts lowest_total_cost
  while !moves.empty? do
    # binding.pry
    path = moves.shift
    # if path.time > n
    #   next
    # end
    # if path.time > largest_time
    #   largest_time = path.time
    #   # puts "time: #{largest_time}"
    # end

    if path.cost > lowest_total_cost
      next
    end

    next_total_cost = path.cost + (n-path.time)*path.flow
    if next_total_cost < lowest_total_cost
      lowest_total_cost = next_total_cost
      puts $starting_flow*n - lowest_total_cost
    end

    
    # binding.pry if path.history.join(",") == "AA,DD,BB,JJ"
    # binding.pry if path.history.join(",") == "AA,DD,BB,JJ,HH"
    # binding.pry if path.history.join(",") == "AA,DD,BB,JJ,HH,EE"
    # binding.pry if paths.key == "AA,BB,CC,DD,EE,HH,JJ"
    if !$visited[path.key] || $visited[path.key].cost > path.cost
      $visited[path.key] = path
      distances = path.valve.distances
      new_paths = distances.filter do |name, d|
        !path.visited.include?(name) && path.time+d < n
      end.map do |name, d|
        cost = path.cost + d*path.flow
        next_flow = path.flow - $valves[name].flow
        time = path.time + d
        Path.new($valves[name], time: time, cost: cost, flow: next_flow, previous: path)
      end
      # binding.pry if path.history.join(",") == "AA,DD,BB,JJ"
      # binding.pry if path.history.join(",") == "AA,DD,BB,JJ,HH"
      # binding.pry if path.history.join(",") == "AA,DD,BB,JJ,HH,EE"
      # binding.pry if paths.key == "AA,BB,CC,DD,EE,HH,JJ"
      moves.concat(new_paths)
      moves = moves.sort_by{|path| path.cost}
    end

  end
  toc
  $results = deep_dup($visited)
  $results.values.each do |path|
    delta = n-path.time
    path.time = n
    path.cost += delta*path.flow
  end
  $results = $results.values.sort_by{|path| path.cost}
  $results.first(100)
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
    @time.to_s + ":" + @visited.to_a.sort.join(',')
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

# explore(30)

def part1
  result = explore(30)[0]
  puts "#{$starting_flow*30-result.cost}" # 1786 is too low
end

# part1