load 'common.rb'
require 'json'
content = File.read("./days/day17.data")
# content = File.read("./days/day17.test.data")
$data = parse_data(content,"\n")
