require_relative 'apicore/API_functions'

app_id = ARGV[0]
puts "Checking prescan results for #{app_id}"
results = veracode_api_request 'getprescanresults.do', app_id: app_id
write results, to_file: "#{app_id}_prescan_results"
