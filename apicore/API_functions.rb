require_relative 'Config'
require 'json'
require 'active_support/core_ext/hash'
require 'rest-client'

def send apicall, params

		puts ">> Making call to #{apicall}"

		response = RestClient.get "https://#{USER}:#{PASS}@analysiscenter.veracode.com/api/4.0/#{apicall}", {:params => params}

		return response.body
end

def veracode_app_list
		send 'getapplist.do', {}
end

def upload_files appid, filepath
	#NOTE: In the line below, the '@' in "@#{filepath}" is a temporary fix for a bug
	#NOTE: in the Veracode API upload call(returned a 'Veracode is under maintenance page.'). Remove this once the fix is implemented.
	send 'uploadfile.do', {:app_id => "#{appid}", :file => "@#{filepath}"}
end

def begin_prescan appid
	send 'beginprescan.do', {:app_id => "#{appid}", :auto_scan => 'true'}
end

def create_veracode_app_profile appname, business_criticality
	send 'createapp.do', {:app_name => "#{appname}", :business_criticality => "#{business_criticality}"}
end

def get_prescan_results appid
	send 'getprescanresults.do', {:app_id => "#{appid}"}
end

def get_build_list appid
	send 'getbuildlist.do', {:app_id => "#{appid}"}
end

def get_detailed_report buildid
	RestClient.get "https://#{USER}:#{PASS}@analysiscenter.veracode.com/api/3.0/detailedreport.do?build_id=#{buildid}"
end

def xml_to_json string
  string = Hash.from_xml(string).to_json
  string = JSON.parse(string)
end

def save_to_file filename, data
	data = xml_to_json data
	f = File.open("testdata/#{filename}.json", 'w')
	f.write data
	f.close
end
