require_relative 'apicore/API_functions'

archive_path = ARGV[0]

appid = ARGV[1]

applist = api 'getapplist.do', {}

if applist.include? appid
  puts '>> Application found in Veracode'
else
  raise 'VeracodeError: Project not found in veracode portfolio.'
end

puts ">> Submitting #{appid}"

#NOTE: '@' in "@#{archive_path}" is temporary mitigation for bug in Veracode api
upload_result = 'uploadfile.do' {:app_id => appid, :file => "@#{archive_path}"}

save_to_file "#{appid}_upload_result", upload_result

submit_prescan_result = api 'beginprescan.do', {:app_id => appid}

save_to_file "#{appid}_submit_prescan_result", submit_prescan_result

puts ">> Submit complete for #{appid}"
