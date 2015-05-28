require_relative 'apicore/API_functions'

appid = ARGV[0]

build_list = get_build_list appid

buildid = build_list.scan(/build_id="(\d{4,10})"/).last[0]

puts ">> Fetching report for #{appid}, build# #{buildid}"

report = get_detailed_report buildid

save_to_file "#{appid}_report", report
