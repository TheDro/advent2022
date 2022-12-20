load 'common.rb'
require 'json'
content = File.read("./days/day20.data")
# content = File.read("./days/day20.test.data")
$pieces = parse_data(content, "\n", ",").map{|row| row.map{|v| v.to_i}}
