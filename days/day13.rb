load 'common.rb'
content = File.read("./days/day13.data")
# content = File.read("./days/day12.test.data")
$height_data = parse_data(content,"\n", "")
