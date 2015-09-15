require 'json'
require 'active_support/core_ext/hash'
require 'rest-client'

module VeracodeApiBase
	def check_environment_login_variables
		fail 'EnvironmentError: USER or PASS not set.' unless ENV['USER'] != nil && ENV['PASS'] != nil
	end

	def veracode_api_request(api_call, api_version: '4.0', **params)
		check_environment_login_variables
		puts "Making call to #{api_call}"
		response = RestClient.get "https://#{ENV['USERNAME']}:#{ENV['PASSWORD']}@analysiscenter.veracode.com/api/#{api_version}/#{api_call}", {:params => params}
		return response.body
	end

	def xml_to_json(string)
		json = Hash.from_xml(string).to_json
		JSON.parse json
	end

	def write(data, to_file:)
		data = xml_to_json data
		f = File.open "../testdata/#{to_file}.json", 'w'
		f.write JSON.pretty_generate data
		f.close
	end
end

module VeracodeApiScan

	include VeracodeApiBase

	def validate_existance(of:)
		app_list = veracode_api_request 'getapplist.do'
		raise 'VeracodeError: Application not found in veracode. Create an Application profile.' unless app_list.include? of
	end

	def submit_scan(app_id, archive_path)
		validate_existance of: app_id
		#NOTE: curl must be used here because of a bug in the Veracode api. Ruby cannot be used while this bug is present.
		#NOTE: preferred code: upload_result = veracode_api_request 'uploadfile.do', app_id: app_id, file: "#{archive_path}"
		upload_result = `curl --url "https://#{ENV['USER']}:#{ENV['PASS']}@analysiscenter.veracode.com/api/4.0/uploadfile.do" -F 'app_id=#{app_id}' -F 'file=@#{archive_path}'`
		write upload_result, to_file: "#{app_id}_upload_result"
		prescan_submission_result = veracode_api_request 'beginprescan.do', app_id: app_id, auto_scan: 'true'
		puts "Submit complete for #{app_id}"
		write prescan_submission_result, to_file: "#{app_id}_prescan_submission_result"
	end
end

module VeracodeApiResults

	include VeracodeApiBase

	def get_most_recent_build_id(using:)
		build_list = veracode_api_request 'getbuildlist.do', app_id: using
		write build_list, to_file: "#{using}_build_list"
		build_id = build_list.scan(/build_id="(.*?)"/).last[0]
	end

	def get_prescan_results(app_id)
		results = veracode_api_request 'getprescanresults.do', app_id: app_id
		puts "Fetched prescan results for #{app_id}"
		write results, to_file: "#{app_id}_prescan_results"
	end

	def get_scan_report(app_id)
		build_id = get_most_recent_build_id using: app_id
		report = veracode_api_request 'detailedreport.do', api_version: '3.0', build_id: build_id
		puts "Fetched report for #{app_id}, build #{build_id}"
		write report, to_file: "#{app_id}_report"
	end
end
