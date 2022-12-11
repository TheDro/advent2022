require 'pry'
load 'common.rb'
content = File.read("./days/day11.data")
# content = File.read("./days/day11.test.data")
monkey_data = parse_data(content,"\n\n")

