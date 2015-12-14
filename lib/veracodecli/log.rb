require 'json'

class ResponseLogger

  # Logger initialization, records the desired log file path.
  def initialize(log_path)
    @path = log_path
  end

  # writes the following information for the passed response string: date & time the call was made, body (response), call name (call), HTTP response code (code). 
  def log(call, code, response)
    log = File.open "#{@path}/veracodecli.log", 'a+'
    log.write "#{call} called @ #{timestamp}"
    log.write "HTTP #{code}\n"
    log.write response
    log.write "\n"
    log.close
  end

  # Returns current system date & time.
  def timestamp
    `date`
  end
end
