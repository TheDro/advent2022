load 'common.rb'
require 'json'
content = File.read("./days/day23.data")
content = File.read("./days/day23.test.data")
$elves = parse_data(content, "\n", "")
