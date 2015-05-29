require 'json'
require 'active_support/core_ext/hash'
require 'rest-client'

def api apicall, params

		puts ">> Making call to #{apicall}"

		response = RestClient.get "https://#{ENV['USER']}:#{ENV['PASS']}@analysiscenter.veracode.com/api/4.0/#{apicall}", {:params => params}   #{ENV['USER']}:#{ENV['PASS']}

		return response.body
end

#NOTE: notice different api version (3.0 not 4.0)
def get_detailed_report buildid
	RestClient.get "https://#{ENV['USER']}:#{ENV['PASS']}@analysiscenter.veracode.com/api/3.0/detailedreport.do?build_id=#{buildid}"
end

def xml_to_json string
  string = Hash.from_xml(string).to_json
  string = JSON.parse(string)
end

def save_to_file filename, data
	data = xml_to_json data
	f = File.open("testdata/#{filename}.json", 'w')
	f.write JSON.pretty_generate data
	f.close
end
