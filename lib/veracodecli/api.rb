require 'json'
require 'active_support/core_ext/hash'
require 'rest-client'

module VeracodeApiBase
  def check_environment_login_variables
    fail 'EnvironmentError: VERACODE_USERNAME or VERACODE_PASSWORD not set.' unless !ENV['VERACODE_USERNAME'].nil? || !ENV['VERACODE_PASSWORD'].nil?
  end

  def veracode_api_request(api_call, api_version: '4.0', **params)
    check_environment_login_variables
    response = RestClient.get "https://#{ENV['VERACODE_USERNAME']}:#{ENV['VERACODE_PASSWORD']}@analysiscenter.veracode.com/api/#{api_version}/#{api_call}", { params: params }
  end

  def get_repo_archive(directory)
    if !Dir.exists?(directory) then `git clone #{args[1]} #{directory}` end
    if Dir.exists?(directory) then `cd #{directory}; git pull; git archive --format=tar -o sast_upload.tar master` else fail 'Repository not found' end
  end
end

module VeracodeApiScan
  include VeracodeApiBase

  def get_app_id(app_name)
    app_list = veracode_api_request 'getapplist.do', include_user_info: 'true'
    scan = app_list.scan(/app_id=\"(.+)\" app_name=\"#{app_name}\"/)
    if !scan.nil? then app_id = scan[0][0] else app_id = nil end
    app_id
  end

  def create_app_profile(app_name, business_criticality, business_unit, teams)
    create_app_response = veracode_api_request 'createapp.do', app_name: app_name, business_criticality: business_criticality, business_unit: business_unit, teams: teams
    app_id = create_app_response.body.scan(/app_id=\"(.+)\" app_name=\"#{app_name}\"/)[0][0]
  end

  def upload_file(app_id, archive_path)
    # NOTE: curl must be used here because of a bug in the Veracode api. rest-client cannot be used while this bug is present.
    # NOTE: preferred code: upload_result = veracode_api_request 'uploadfile.do', app_id: app_id, file: "#{archive_path}"
    upload_file_response = `curl --url "https://#{ENV['VERACODE_USERNAME']}:#{ENV['VERACODE_PASSWORD']}@analysiscenter.veracode.com/api/4.0/uploadfile.do" -F 'app_id=#{app_id}' -F 'file=@#{archive_path}'`
  end

  def submit_prescan(app_id)
    submit_prescan_response = veracode_api_request 'beginprescan.do', app_id: app_id, auto_scan: 'true'
  end
end

module VeracodeApiResults
  include VeracodeApiBase

  def get_most_recent_build_id(app_id)
    build_list = veracode_api_request 'getbuildlist.do', app_id: app_id
    build_list.body.scan(/build_id="(.*?)"/).last[0]
  end

  def get_build_status(app_id)
    build_info = veracode_api_request 'getbuildinfo.do', app_id: app_id
    build_id = build_info.body.scan(/build_id="(.*?)"/)[0][0]
    build_status = build_info.body.scan(/status="(.*?)"/).last[0]
    puts build_status
    build_status
  end

  def get_prescan_results(app_id)
    results = veracode_api_request 'getprescanresults.do', app_id: app_id
    puts "Fetched prescan results for #{app_id}"
    puts results.body
    results
  end

  def get_scan_report(build_id)
    report = veracode_api_request 'detailedreport.do', api_version: '3.0', build_id: build_id
    report = report.body
  end

  def get_scan_report_pdf(build_id)
    report = veracode_api_request 'detailedreportpdf.do', api_version: '3.0', build_id: build_id
    report = report.body
  end
end

module VeracodeApiMacros
  include VeracodeApiScan
  include VeracodeApiResults

  def submit_scan_macro(app_name, business_criticality, business_unit, teams, archive_path)
    app_id = get_app_id(app_name)
    if app_id.nil?
      app_id = create_app_profile(app_name, business_criticality, business_unit, teams)
    end
    upload_file app_id, archive_path
    submit_prescan app_id
  end

  def get_report_macro(app_name)
    app_id = get_app_id app_name
    build_id = get_most_recent_build_id app_id
    report = get_scan_report build_id
  end

  def get_pdf_macro(app_name)
    app_id = get_app_id app_name
    build_id = get_most_recent_build_id app_id
    report = get_scan_report build_id
  end

end
