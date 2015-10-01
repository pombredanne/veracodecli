require 'json'
require 'active_support/core_ext/hash'
require 'rest-client'

module VeracodeApiBase
  def check_environment_login_variables
    fail 'EnvironmentError: VERACODE_USERNAME, VERACODE_PASSWORD, or VERACODE_TEAM not set.' unless !ENV['VERACODE_USERNAME'].nil? || !ENV['VERACODE_PASSWORD'].nil? || !ENV['VERACODE_TEAM'].nil?
  end

  def veracode_api_request(api_call, api_version: '4.0', **params)
    check_environment_login_variables
    # puts "Making call to #{api_call}"
    response = RestClient.get "https://#{ENV['VERACODE_USERNAME']}:#{ENV['VERACODE_PASSWORD']}@analysiscenter.veracode.com/api/#{api_version}/#{api_call}", { params: params }
    response.body
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
    puts "Validating records for #{of}"
    app_list = veracode_api_request 'getapplist.do', include_user_info: 'true'
    if app_list.include? "#{of}"
      puts 'Record found, submitting'
      return app_list.scan(/app_id=\"(.+)\" app_name=\"#{of}\"/)[0][0]
    else
      puts 'Record not found, creating one'
      create_app_result = veracode_api_request 'createapp.do', app_name: of, description: "Static Scanning profile for #{of}.", business_criticality: 'High', business_unit: "#{ENV['VERACODE_TEAM']}", web_application: 'true', teams: "#{ENV['VERACODE_TEAM']}"
      app_id = create_app_result.scan(/app_id=\"(.+)\" app_name=\"#{of}\"/)[0][0]
      puts "Record successfully created, app_id is #{app_id}"
      return app_id
    end
  end

  def submit_scan(hostname, archive_path)
    app_id = validate_existance of: hostname
    # NOTE: curl must be used here because of a bug in the Veracode api. rest-client cannot be used while this bug is present.
    # NOTE: preferred code: upload_result = veracode_api_request 'uploadfile.do', app_id: app_id, file: "#{archive_path}"
    upload_result = `curl --url "https://#{ENV['VERACODE_USERNAME']}:#{ENV['VERACODE_PASSWORD']}@analysiscenter.veracode.com/api/4.0/uploadfile.do" -F 'app_id=#{app_id}' -F 'file=@#{archive_path}'`
    puts upload_result
    # write upload_result, to_file: "#{app_id}_upload_result"
    prescan_submission_result = veracode_api_request 'beginprescan.do', app_id: app_id, auto_scan: 'true'
    puts prescan_submission_result
    puts "Submit complete for #{app_id}"
    # File.write 'VERACODE_SCAN_RESULT_CHECK_QUEUE', app_id
    # write prescan_submission_result, to_file: "#{app_id}_prescan_submission_result"
  end
end

module VeracodeApiResults
  include VeracodeApiBase

  def get_most_recent_build_id(using:)
    build_list = veracode_api_request 'getbuildlist.do', app_id: using
    # write build_list, to_file: "#{using}_build_list"
    build_list.scan(/build_id="(.*?)"/).last[0]
  end

  def get_build_status(app_id)
    build_info = veracode_api_request 'getbuildinfo.do', app_id: app_id
    build_id = build_info.scan(/build_id="(.*?)"/)[0][0]
    build_status = build_info.scan(/status="(.*?)"/).last[0]
    puts build_status
  end

  def get_prescan_results(app_id)
    results = veracode_api_request 'getprescanresults.do', app_id: app_id
    puts "Fetched prescan results for #{app_id}"
    # write results, to_file: "#{app_id}_prescan_results"
  end

  def get_scan_report(app_id)
    build_id = get_most_recent_build_id using: app_id
    report = veracode_api_request 'detailedreport.do', api_version: '3.0', build_id: build_id
    puts "Fetched report for #{app_id}, build #{build_id}"
    # write report, to_file: "#{app_id}_report"
  end
end
