load 'common.rb'
content = File.read("./days/day12.data")
# content = File.read("./days/day12.test.data")
$monkey_data = parse_data(content,"\n\n")

