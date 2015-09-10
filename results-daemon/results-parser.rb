require_relative '/home/isaiah/webchannel-ci/log/loggers/logs'

class Veracodeparser

  #for larger results we can have hashes of arrays of hashes of arrays etc...
  def self.recursive_search(result)
    self.hash_search(result) if result.is_a? Hash
    self.array_search(result) if result.is_a? Array
  end

  #search the hash for relevant information
  def self.hash_search(result)
    self.find_project_info(result)
    result.each do |key, value|
      if self.found_issue(key)
        self.parse_flaws(value)
      elsif self.found_error(key)
        self.parse_errors(value)
      elsif self.found_api_results(key)
        self.parse_response(key,value)
      else
        self.recursive_search(value)
      end
    end
  end

  def self.array_search(result)
    result.each do |element|
      self.recursive_search(element)
    end
  end

  def self.find_project_info(result)
    @@project_name = result['app_name'] if result.has_key?('app_name')
    @@project_id = result['app_id'] if result.has_key?('app_id')
    @@build_id = result['build_id'] if result.has_key?('build_id')
  end

  def self.found_issue(key)
    if key == 'flaw' then return true else return false end
  end

  def self.found_error(key)
    if key == 'error' then return true else return false end
  end

  def self.found_api_results(key)
    puts key
    gets
    if %w(file analysis_unit prescanresults).any? {|word| key == word} then return true else return false end
  end

#Grabs relevant error information and logs
  def self.parse_errors(error)
    @log = LogsLogger
    @log.log 'Sec-Suite', data: {
      error: error
    }
    $error_count += 1
  end

#logs relevant api-call response data
  def self.parse_response(key, response)
    @log = LogsLogger
    case key
    when 'file'
      puts '>> logging upload response'
      @log.log 'Sec-Upload', data: {
        app_id: @@project_id,
        build_id: @@build_id,
        file_name: response['file_name'],
        file_status: response['file_status']
      }
    when 'analysis_unit'
      puts '>> logging prescan submission response'
      @log.log 'Sec-Prescan-Submit', data: {
        app_id: @@project_id,
        build_id: @@build_id,
        prescan_status: response['status']
      }
    when 'prescanresults'
      puts '>> logging prescan results'
      @log.log 'Sec-Prescan-Results', data: {
        app_id: response['app_id'],
        build_id: response['build_id'],
        fatal_prescan_errors?: response['module']['has_fatal_errors'],
        issues: response['module']['issue']
      }
    end
  end

#Grabs relevant data from flaws and logs
  def self.parse_flaws(flaws)
    puts '>> logging scan results'
    @logs = LogsLogger
    if flaws.is_a?(Array)
      flaws.each do |flaw|
        self.parse_flaws(flaw)
      end
    else
      @logs.log 'Sec-Suite', data: {
        project: @@project_name,
        issueid: flaws['issueid'],
        severity: flaws['severity'],
        categoryname: flaws['categoryname'],
        sourcefile: flaws['sourcefile'],
        line: flaws['line#'],
        cweid: flaws['cweid']
      }
      $flaw_count += 1
    end
  end

end
