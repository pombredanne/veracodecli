require_relative 'apicore/API_functions'

archive_path = ARGV[0]
app_id = ARGV[1]
app_list = veracode_api_request 'getapplist.do'
raise 'VeracodeError: Application not found in veracode. Create an Application profile.' unless app_list.include? app_id
#NOTE: '@' in "@#{archive_path}" is temporary mitigation for bug in Veracode api
upload_result = veracode_api_request 'uploadfile.do', app_id: app_id, file: "@#{archive_path}"
write upload_result, to: "#{app_id}_upload_result"
prescan_submission_result = veracode_api_request 'beginprescan.do', app_id: app_id, auto_scan: 'true'
write prescan_submission_result, to: "#{app_id}_prescan_submission_result"
puts "Submit complete for #{app_id}"
