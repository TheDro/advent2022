load 'common.rb'
require 'json'
content = File.read("./days/day16.data")
# content = File.read("./days/day16.test.data")
$data = parse_data(content,"\n")
