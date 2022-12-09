require 'pry'
load 'common.rb'
content = File.read("./days/day09.data")
# content = File.read("./days/day09.test.data")
$moves = parse_data(content,"\n"," ")
