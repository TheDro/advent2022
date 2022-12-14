load 'common.rb'
require 'json'
content = File.read("./days/day14.data")
# content = File.read("./days/day14.test.data")
$data = parse_data(content,"\n", " -> ")
# $data = $data.map do |row|



