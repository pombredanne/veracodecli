require 'settingslogic'
require 'terminal-announce'

# require_relative 'interactive_setup'

# Singleton for loading configs from common paths.
class Settings < Settingslogic
  # include InteractiveSetup

  config_path = "/etc"

  config_file = File.expand_path "#{config_path}/veracodecli.yaml"
  source config_file if File.exist? config_file

  load!
rescue Errno::ENOENT
  Announce.failure "Unable to find a configuration at #{config_path}/veracodecli.yml"
  exit
  # InteractiveSetup.start
end
