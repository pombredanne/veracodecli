require_relative 'results-parser'
require 'json'
require 'yaml'
require 'active_support/core_ext/hash'
require_relative '/home/isaiah/webchannel-ci/log/loggers/metrics'

def parse_results jsonstring

  @metrics = MetricsLogger

  result = jsonstring

  $flaw_count = 0
  $error_count = 0

  Veracodeparser.recursive_search result

  @metrics.log 'Sec-Suite', data: {
    issue_count: $flaw_count,
    error_count: $error_count
  }

  puts '>> Done'

end

file = ARGV[0]

file = File.read(file)

jsonstring = JSON.parse(file.gsub("\n",''))

parse_results jsonstring
