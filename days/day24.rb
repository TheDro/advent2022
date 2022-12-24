load 'common.rb'
require 'json'
content = File.read("./days/day24.data")
# content = File.read("./days/day24.test.data")
$elves = parse_data(content, "\n", "")