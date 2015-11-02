require 'json'

class ResponseLogger

  def initialize(log_path)
    @path = log_path
  end

  def log(call, response)
    log = File.open "#{@path}/veracodecli.log", 'a+'
    log.write "#{call} called @ #{timestamp}"
    log.write response
    log.write "\n"
    log.close
  end

  def timestamp
    `date`
  end
end
