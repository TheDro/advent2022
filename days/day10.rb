require 'pry'
load 'common.rb'
content = File.read("./days/day10.data")
# content = File.read("./days/day10.test.data")
$moves = parse_data(content,"\n"," ")

