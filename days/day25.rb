load 'common.rb'
require 'json'
content = File.read("./days/day25.data")
# content = File.read("./days/day25.test.data")
$data = parse_data(content, "\n", "")
