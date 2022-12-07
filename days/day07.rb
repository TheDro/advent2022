require 'pry'
# load './days/day07.rb'
content = File.read("./days/day07.data")
# content = File.read("./days/day07.test.data")

$commands = content.split("\n")




class Folder
  attr_accessor :name, :files, :folders, :parent

  def initialize(name, parent)
    @name = name #String
    @files = {} # String:Number
    @folders = {} # String:Folder
    @parent = parent #Folder
  end

  def add_file(name, size)
    @files[name] = size
  end

  def add_folder(name)
    @folders[name] = Folder.new(name, self)
  end

  def self_size()
    total = @files.values.sum
    total += @folders.values.sum(&:self_size)
    total
  end

  def all_sizes()
    [*@files.values, *@folders.values.map(&:all_sizes)]
  end

  def [](name)
    @folders[name] || @files[name]
  end

  def inspect()
    "<Folder #{@name}/ #{@folders.keys.join('/ ')}/ #{files} parent:#{parent&.name}>"
  end
end


def parse_folders
  all_folders = []
  root = Folder.new('/', nil)
  cursor = root
  all_folders.push(root)
  $commands.each do |command|
    # binding.pry
    if command == "$ cd /"
      puts "move to /"
      cursor = root
    elsif match = /\$ cd (\w+)/.match(command)
      puts "move to #{match[1]}"
      cursor = cursor.folders[match[1]]
    elsif command == "$ cd .."
      puts "move up"
      cursor = cursor.parent
    elsif command == "$ ls"
      # do nothing
    elsif match = /dir (\w+)/.match(command)
      cursor.add_folder(match[1])
      all_folders.push(cursor.folders[match[1]])
    elsif match = /(\d+) ([\w.]+)/.match(command)
      cursor.add_file(match[2], match[1].to_i)
    end
  end
  all_folders
end

def part1(folders)
  sizes = folders.map do |folder|
    folder.all_sizes.flatten.sum
  end

  sum1 = $sizes.sum do |size|
    size <= 100000 ? size : 0
  end
  
  puts "part1: #{sum1}"
  sum1
end

def part2(folders)
  total_size = folders[0].all_sizes.flatten.sum
  required_space = total_size - 40_000_000
  sizes = folders.map do |folder|
    folder.all_sizes.flatten.sum
  end.sort

  smaller_sizes = sizes.filter{|size| size < required_space }
  puts "required space: #{required_space}"
  puts "part2: #{sizes[smaller_sizes.length]}"
  binding.pry
  smaller_sizes.last
end

$folders = parse_folders
part1($folders)
part2($folders)



