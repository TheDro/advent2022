load 'common.rb'
require 'json'
content = File.read("./days/day21.data")
# content = File.read("./days/day21.test.data")
$data = parse_data(content, "\n")
