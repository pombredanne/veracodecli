require_relative 'apicore/API_functions'

archive_path = ARGV[0]

appid = ARGV[1]

applist = veracode_app_list

if applist.include? appid
  puts '>> Application found in Veracode'
else
  raise 'VeracodeError: Project not found in veracode portfolio.'
end

puts ">> Submitting #{appid}"

upload_result = upload_files app_id, "#{archive_path}"

save_to_file "#{appid}_upload_result", upload_result

prescan_result = begin_prescan app_id

save_to_file "#{appid}_prescan_result", prescan_result

puts ">> Submit complete for #{appid}"
