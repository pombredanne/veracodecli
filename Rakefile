# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = "veracodecli"
  gem.homepage = "http://github.com/isand3r/veracodecli"
  gem.license = "MIT"
  gem.summary = %Q{Ruby based CLI for accessing veracode's api}
  gem.description = %Q{Ruby based CLI for accessing veracode's api}
  gem.email = "isaiah.thiessen@telus.com"
  gem.authors = ["isaiah thiessen"]
  gem.files = ["lib/veracodecli/api.rb", "lib/veracodecli", "bin/veracodecli"]
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables   = ['veracodecli']
  gem.require_paths = ['lib', 'lib/veracodecli']
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

desc "Code coverage detail"
task :simplecov do
  ENV['COVERAGE'] = "true"
  Rake::Task['test'].execute
end

require 'reek/rake/task'
Reek::Rake::Task.new do |t|
  t.fail_on_error = true
  t.verbose = false
  t.source_files = 'lib/**/*.rb'
end

require 'roodi'
require 'roodi_task'
RoodiTask.new do |t|
  t.verbose = false
end

task :default => :test

require 'yard'
YARD::Rake::YardocTask.new
