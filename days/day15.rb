load 'common.rb'
require 'json'
content = File.read("./days/day15.data")
# content = File.read("./days/day15.test.data")
$data = parse_data(content,"\n", " -> ")

