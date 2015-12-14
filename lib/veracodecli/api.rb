require 'json'
require 'active_support/core_ext/hash'
require 'rest-client'
require 'yaml'
require 'nokogiri'
require_relative 'settings'
require_relative 'log'

# Base Module. Contains parsing and rest call functions.
module VeracodeApiBase
  # Makes a REST request to analysiscenter.veracode.com/api/[version]/[function], where function is the passed api_call	method argument,
  # api_version is the passed method argument with default value '4.0', and params is any number of json key:value pairs passed in the **params method argument.
  # The response is logged to /tmp/veracodecli.log as long as the HTTP response code = 200. 5XX or 4XX raise an Error.
  def veracode_api_request(api_call, api_version: '4.0', **params)
    begin
      # RestClient.proxy = Settings.proxy unless !Settings.proxy
      response = RestClient.get "https://#{Settings.veracode_username}:#{Settings.veracode_password}@analysiscenter.veracode.com/api/#{api_version}/#{api_call}", { params: params }
      log = ResponseLogger.new "/tmp"
      log.log api_call, response.code, response.body
    rescue RestClient
      abort '401: Unauthorized. Veracode API call Failed, please check your veracode credentials or whitelisted IPs'
    end
    if [500,501,502,503].any?{|code| response.code == code} then abort 'Internal server error.' end
    response
  end

  # Clones or updates a git clone of the desired directory (set in the configuration file), then zips the contents to /temp/sast_upload.zip.
  def get_repo_archive(url)
    directory = "/tmp/sast_clone"
    if Dir.exists?(directory)
      `cd #{directory}; git pull`
    else
      `git clone #{url} #{directory}`
    end
    `cd /tmp; zip -r sast_upload.zip sast_clone`
  end

  # Returns the passed xml 'response' for the 'app_id' attribute associated with the passed 'app_name' for the 'getapplist' call. 
  def response_parse_app_id(response, app_name)
    app_id = nil
    doc = Nokogiri::XML response
    doc.remove_namespaces!
    if doc.xpath('//app').empty? then return nil end
    doc.xpath('//app').each do |app|
      app_id = app.attributes['app_id'].value unless app.attributes['app_name'].value != app_name
    end
    app_id
  end

  # Returns the passed xml 'response' for the 'app_id' attribute for the 'createapp' call.
  def parse_new_app_id(response)
    app_id = nil
    doc = Nokogiri::XML response
    doc.remove_namespaces!
    if doc.xpath('//application').empty? then return nil end
    doc.xpath('//application').each do |application|
      app_id = application.attributes['app_id'].value
    end
    app_id
  end
end

# Scan Module. Contains all functions necessary to submit a scan. 
module VeracodeApiScan
  include VeracodeApiBase

  # calls getapplist and returns the ''app_id' attribute associated with the passed 'app_name' argument.  
  def get_app_id(app_name)
    app_list = veracode_api_request 'getapplist.do', include_user_info: 'true'
    app_id = response_parse_app_id app_list.body, app_name
  end

  # calls 'createapp' to create an new app profile. All arguments are required and can be specified in the config file.
  def create_app_profile(app_name, business_criticality, business_unit, team)
    create_app_response = veracode_api_request 'createapp.do', app_name: app_name, business_criticality: business_criticality, business_unit: business_unit, teams: team
    app_id = parse_new_app_id create_app_response.body
    if app_id.nil? then abort 'createapp failed. Check the logs.' end
  end

  # Calls 'uploadfile' to upload the previously created 'sast_upload.zip'.
  def upload_file(app_id, archive_path)
    # NOTE: curl must be used here because of a bug in the Veracode api. rest-client cannot be used while this bug is present.
    # NOTE: preferred code: upload_result = veracode_api_request 'uploadfile.do', app_id: app_id, file: "#{archive_path}"
    `curl --url "https://#{Settings.veracode_username}:#{Settings.veracode_password}@analysiscenter.veracode.com/api/4.0/uploadfile.do" -F 'app_id=#{app_id}' -F 'file=@#{archive_path}'`
  end

  # calls 'beginprescan' for the passed app_id argument. 'auto_scan: 'true'' means that the scan will begin automatically after the prescan unless there are errors.
  def submit_prescan(app_id)
    veracode_api_request 'beginprescan.do', app_id: app_id, auto_scan: 'true'
  end
end

# Results module. Contains all methods necessary to download scan reports.
module VeracodeApiResults
  include VeracodeApiBase

  # calls 'getbuildlist' and returns the last 'build_id' attribute associated with the passed app_id  
  def get_most_recent_build_id(app_id)
    build_list = veracode_api_request 'getbuildlist.do', app_id: app_id
    build_list.body.scan(/build_id="(.*?)"/).last[0]
  end
  
  # calls 'getprescanresults'
  def get_prescan_results(app_id)
    results = veracode_api_request 'getprescanresults.do', app_id: app_id
    puts "Fetched prescan results for #{app_id}"
    puts results.body
    results
  end

  # calls 'detailedreport' for the passed 'build_id' attribute, returning the xml body of the response. Note that this api is version 3.0 not 4.0.
  def get_scan_report(build_id)
    report = veracode_api_request 'detailedreport.do', api_version: '3.0', build_id: build_id
    report.body
  end

  # similar to above method, except returns a pdf response instead of xml.
  def get_scan_report_pdf(build_id)
    report = veracode_api_request 'detailedreportpdf.do', api_version: '3.0', build_id: build_id
    report.body
  end
end

# Macros module. Contains sequenced method calls from above modules to perform actions such as submitting scans, retreiving reports.
module VeracodeApiMacros
  include VeracodeApiScan
  include VeracodeApiResults

  def submit_scan_macro(app_name, business_criticality, business_unit, team)
    archive_path = "/tmp/sast_upload.zip"
    app_id = get_app_id(app_name)
    if app_id.nil?
      app_id = create_app_profile(app_name, business_criticality, business_unit, team)
    end
    upload = upload_file app_id, archive_path
    ResponseLogger.new('/tmp').log 'uploadfile.do', '', upload
    submit_prescan app_id
    File.delete archive_path
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
