require 'mini-smtp-server'

class StdoutSmtpServer < MiniSmtpServer

  def new_message_event(message_hash)
    puts "# New email received:"
    puts "-- From: #{message_hash[:from]}"
    puts "-- To:   #{message_hash[:to]}"
    puts "--"
    puts "-- " + message_hash[:data].gsub(/\r\n/, "\r\n-- ")
    puts
  end

end

server = StdoutSmtpServer.new(2525, "127.0.0.1", 4)
puts 'Mini SMTP starting...'
server.start
puts 'Started.'
server.join
