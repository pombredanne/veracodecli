require_relative 'apicore/API_functions'

app_id = ARGV[0]
build_list = veracode_api_request 'getbuildlist.do', app_id: app_id
write build_list, to_file: "#{app_id}_build_list"
build_id = get_most_recent_build_id from: build_list
puts "Fetching report for #{app_id}, build #{build_id}"
report = veracode_api_request 'detailedreport.do', api_version: '3.0', build_id: build_id
write report, to_file: "#{app_id}_report"
