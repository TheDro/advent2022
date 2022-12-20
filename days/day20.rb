load 'common.rb'
require 'json'
content = File.read("./days/day20.data")
# content = File.read("./days/day20.test.data")
$data = parse_data(content, "\n").map(&:to_i)

Node = Struct.new(:index, :value)


def show(nodes)
  puts nodes.map(&:value).join(",")
end

def rotate(data=$data.dup, mixes=1)

  nodes = nodify(data)

  n = nodes.size
  # search_pos = 0
  mixes.times do
    n.times do |i|
      from_pos = find_index(i, 0, nodes)
      # search_pos = from_pos
      node = nodes[from_pos]
      to_pos = (from_pos + node.value) % (n-1)

      # binding.pry
      to_pos = n-1 if to_pos == 0 && from_pos != 0

      nodes.slice!(from_pos)
      nodes.insert(to_pos, node)
    end
    # puts nodes.map(&:value).join(", ")
  end
  return nodes.map(&:value)
end


def nodify(data)
  result = []
  data.size.times do |i|
    result.push(Node.new(i, data[i]))
  end
  result
end

def find_index(index, search_pos, nodes)
  (search_pos..nodes.size-1).each do |i|
    if nodes[i].index == index
      return i
    end
  end
end



# def rotate(data=$data.dup)
#   offset = 0
#   n = data.size
#   n.times do |i|
#     from_pos = i+offset
#     value = data[from_pos]
#     to_pos = (from_pos + value) % n
#     binding.pry
#     if (to_pos - from_pos) <= 0
#       offset = offset
#     else
#       offset += -1
#     end

#     data.slice!(from_pos)
#     data.insert(to_pos, value)
#   end
#   return data
# end

def part1
  rotated_data = rotate
  n = rotated_data.size
  start_pos = rotated_data.find_index(0)
  result = 
    rotated_data[(start_pos + 1000) % n] + 
    rotated_data[(start_pos + 2000) % n] + 
    rotated_data[(start_pos + 3000) % n]
end

def part2
  real_data = $data.map do |value|
    value*811589153
  end
  rotated_data = real_data
  # puts rotated_data.join(",")
  rotated_data = rotate(real_data, 10)

  # 10.times do |i|
  #   rotated_data = rotate(rotated_data)
  #   puts rotated_data.join(",")
  # end

  n = rotated_data.size
  start_pos = rotated_data.find_index(0)
  result = 
    rotated_data[(start_pos + 1000) % n] + 
    rotated_data[(start_pos + 2000) % n] + 
    rotated_data[(start_pos + 3000) % n]
end


# puts part1
# puts part2