require 'json'
require 'active_support/core_ext/hash'
require 'rest-client'
require 'yaml'
require_relative 'settings'
require_relative 'log'

module VeracodeApiBase
  def veracode_api_request(api_call, api_version: '4.0', **params)
    begin
      response = RestClient.post "https://#{Settings.veracode_username}:#{Settings.veracode_password}@analysiscenter.veracode.com/api/#{api_version}/#{api_call}", { params: params }
      log = ResponseLogger.new "/home/#{ENV['USER']/veracodecli_data}"
      log.log response.body
    rescue
      abort '401: Unauthorized. Veracode API call Failed, please check your veracode credentials or whitelisted IPs'
    end
    response
  end

  def get_repo_archive(url)
    directory = "/tmp/sast_clone"
    if Dir.exists?(directory)
      `cd #{directory}; git pull`
    else
      `git clone #{url} #{directory}/sast_clone`
    end
    `cd /tmp; zip -r sast_upload.zip sast_clone`
    # `git archive --remote #{url} --format=tar -o #{directory}/sast_upload.tar master`
  end
end

module VeracodeApiScan
  include VeracodeApiBase

  def get_app_id(app_name)
    app_list = veracode_api_request 'getapplist.do', include_user_info: 'true'
    scan = app_list.body.scan(/app_id=\"(.+)\" app_name=\"#{app_name}\"/)
    begin
      app_id = scan[0][0]
    rescue
      app_id = nil
    end
    app_id
  end

  def create_app_profile(app_name, business_criticality, business_unit, team)
    create_app_response = veracode_api_request 'createapp.do', app_name: app_name, business_criticality: business_criticality, business_unit: business_unit, teams: team
    create_app_response.body.scan(/app_id=\"(.+)\" app_name=\"#{app_name}\"/)[0][0]
  end

  def upload_file(app_id, archive_path)
    # NOTE: curl must be used here because of a bug in the Veracode api. rest-client cannot be used while this bug is present.
    # NOTE: preferred code: upload_result = veracode_api_request 'uploadfile.do', app_id: app_id, file: "#{archive_path}"
    `curl --url "https://#{Settings.veracode_username}:#{Settings.veracode_password}@analysiscenter.veracode.com/api/4.0/uploadfile.do" -F 'app_id=#{app_id}' -F 'file=@#{archive_path}'`
  end

  def submit_prescan(app_id)
    veracode_api_request 'beginprescan.do', app_id: app_id, auto_scan: 'true'
  end
end

module VeracodeApiResults
  include VeracodeApiBase

  def get_most_recent_build_id(app_id)
    build_list = veracode_api_request 'getbuildlist.do', app_id: app_id
    build_list.body.scan(/build_id="(.*?)"/).last[0]
  end

  # def get_build_status(app_id)
  #   build_info = veracode_api_request 'getbuildinfo.do', app_id: app_id
  #   build_id = build_info.body.scan(/build_id="(.*?)"/)[0][0]
  #   build_status = build_info.body.scan(/status="(.*?)"/).last[0]
  #   puts build_status
  #   build_status
  # end

  def get_prescan_results(app_id)
    results = veracode_api_request 'getprescanresults.do', app_id: app_id
    puts "Fetched prescan results for #{app_id}"
    puts results.body
    results
  end

  def get_scan_report(build_id)
    report = veracode_api_request 'detailedreport.do', api_version: '3.0', build_id: build_id
    report.body
  end

  def get_scan_report_pdf(build_id)
    report = veracode_api_request 'detailedreportpdf.do', api_version: '3.0', build_id: build_id
    report.body
  end
end

module VeracodeApiMacros
  include VeracodeApiScan
  include VeracodeApiResults

  def submit_scan_macro(app_name, business_criticality, business_unit, team)
    archive_path = "/tmp/sast_upload.zip"
    app_id = get_app_id(app_name)
    if app_id.nil?
      app_id = create_app_profile(app_name, business_criticality, business_unit, team)
    end
    upload_file app_id, archive_path
    submit_prescan app_id
  end

  def get_report_macro(app_name)
    app_id = get_app_id app_name
    build_id = get_most_recent_build_id app_id
    p get_scan_report build_id
  end

  def get_pdf_macro(app_name)
    app_id = get_app_id app_name
    build_id = get_most_recent_build_id app_id
    report = get_scan_report_pdf build_id
    file_path = "/tmp/#{build_id}_report.pdf"
    file = File.open file_path, 'w+'
    file.write report
    file.close
    return file_path
  end
end
