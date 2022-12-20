load 'common.rb'
require 'json'
content = File.read("./days/day19.data")
content = File.read("./days/day19.test.data")
$blueprints = parse_data(content, "\n").map do |row| 
  match = /Blueprint (\d+): Each ore robot costs (\d+) ore. Each clay robot costs (\d+) ore. Each obsidian robot costs (\d+) ore and (\d+) clay. Each geode robot costs (\d+) ore and (\d+) obsidian./.match(row)
  values = (1..7).map{|i| match[i].to_i}
  costs = [[values[1], 0, 0], [values[2], 0, 0],  [values[3], values[4], 0], [values[5], 0, values[6]]]
end


class Path
  attr_accessor :build_index, :robots, :resources, :score, :time, :previous, :history
  def initialize(build_index, robots:, resources:, score:, time:, previous:)
    @build_index = build_index
    @robots = robots
    @resources = resources
    @time = time
    @previous = previous
    @score = score

    @history = (previous&.history || []) + [build_index]
  end

  def key
    "#{@time}: #{@robots.join(',')}; #{@resources.join(',')}"
  end

  def inspect
    "<Path:#{object_id} robots: #{robots.join(',')} resources: #{resources.join(',')} score: #{score} time: #{time} history: #{history.join(",")}>"
  end
end

def add(array1, array2)
  array1.zip(array2).map{|a,b| a+b}
end

def mult(array1, array2)
  array1.zip(array2).map{|a,b| a*b}
end

def divide(array1, array2)
  array1.zip(array2).map{|a,b| a == 0 ? 0 : a.to_f/b}
end

def subtract(array1, array2)
  array1.zip(array2).map{|a,b| a-b}
end


def play(n)

  moves = [$start = Path.new(0, robots: [1,0,0,0], resources: [0,0,0], score: 0, time: 0, previous: nil)]
  costs = $blueprints[0]
  $visited = {}

  iterations = 0
  highest_score = 0
  while !moves.empty?
    # binding.pry
    iterations += 1
    if (iterations % 10_000 == 0)
      puts "iteration #{iterations}: #{moves.size} moves left. High score: #{highest_score}"
    end
    path = moves.shift()
    
    if !$visited[path.key] || $visited[path.key].score < path.score
      $visited[path.key] = path
      possible_robots(path.robots).each do |robot_index|
        time_left = n-path.time
        if (time_left*(time_left-1))/2 + path.score < highest_score
          next
        end

        cost = costs[robot_index]
        d = divide(subtract(cost, path.resources), path.robots[0..2]).max.ceil+1
        d = [d, 1].max
        resources = add(path.resources, path.robots[0..2].map{|r| r*d})
        resources = subtract(resources, cost)
        if (resources.any? {|r| r<0})
          binding.pry
        end
        robots = path.robots.dup
        robots[robot_index] += 1
        score = path.score
        time = path.time + d
        if time >= n
          next
        end
        if robot_index == 3
          score += (n-time)
          if score > highest_score
            highest_score = score
          end
        end
        new_path = Path.new(robot_index, robots:, resources:, score:, time:, previous: path)
        moves << new_path
      end

    end
  end

  results = $visited.sort_by{|key,path| -path.score}.first(20)
  binding.pry
  results
end

def possible_robots(robots)
  results = []
  if robots[0] > 0
    results += [0,1]
  end
  if robots[1] > 0
    results += [2]
  end
  if robots[2] > 0
    results += [3]
  end
  results
end
