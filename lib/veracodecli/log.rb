require 'json'

class ResponseLogger

  def initialize(log_path)
    @path = log_path
  end

  def log(call, code, response)
    check_log_file "#{@path}/veracodecli.log"
    log = File.open "#{@path}/veracodecli.log", 'a+'
    log.write "#{call} called @ #{timestamp}"
    log.write "HTTP #{code}\n"
    log.write response
    log.write "\n"
    log.close
  end

  def check_log_file(file_path)
    File.open file_path, 'w' unless File.exist? file_path
  end

  def timestamp
    `date`
  end
end
