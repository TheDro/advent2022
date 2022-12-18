load 'common.rb'
require 'json'
content = File.read("./days/day17.data")
# content = File.read("./days/day17.test.data")
$directions = parse_data(content, "")
