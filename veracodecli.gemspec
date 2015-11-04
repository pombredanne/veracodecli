# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: veracodecli 1.0.12 ruby lib

Gem::Specification.new do |s|
  s.name = "veracodecli"
  s.version = "1.0.12"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["isaiah thiessen"]
  s.date = "2015-11-04"
  s.description = "Ruby based CLI for accessing veracode's api"
  s.email = "isaiah.thiessen@telus.com"
  s.executables = ["veracodecli"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".document",
    ".gitignore",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "bin/veracodecli",
    "lib/veracodecli.rb",
    "lib/veracodecli/api.rb",
    "lib/veracodecli/log.rb",
    "lib/veracodecli/settings.rb",
    "lib/veracodecli/slack.rb",
    "test/API.rb",
    "test/helper.rb",
    "test/test_veracodecli.rb",
    "veracodecli.gemspec"
  ]
  s.homepage = "http://github.com/isand3r/veracodecli"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.8"
  s.summary = "Ruby based CLI for accessing veracode's api"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, ["~> 4.2"])
      s.add_runtime_dependency(%q<commander>, ["~> 4.3"])
      s.add_runtime_dependency(%q<json>, ["~> 1.8"])
      s.add_runtime_dependency(%q<rest-client>, ["~> 1.8"])
      s.add_runtime_dependency(%q<settingslogic>, ["~> 2.0"])
      s.add_runtime_dependency(%q<terminal-announce>, ["~> 1.0"])
      s.add_runtime_dependency(%q<nokogiri>, ["~> 1.6"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 2.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<reek>, ["~> 1.2"])
      s.add_development_dependency(%q<roodi>, ["~> 2.1"])
      s.add_development_dependency(%q<shoulda>, ["~> 3.5"])
      s.add_development_dependency(%q<rubocop>, ["~> 0.32"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.10"])
      s.add_development_dependency(%q<yard>, ["~> 0.7"])
    else
      s.add_dependency(%q<activesupport>, ["~> 4.2"])
      s.add_dependency(%q<commander>, ["~> 4.3"])
      s.add_dependency(%q<json>, ["~> 1.8"])
      s.add_dependency(%q<rest-client>, ["~> 1.8"])
      s.add_dependency(%q<settingslogic>, ["~> 2.0"])
      s.add_dependency(%q<terminal-announce>, ["~> 1.0"])
      s.add_dependency(%q<nokogiri>, ["~> 1.6"])
      s.add_dependency(%q<bundler>, ["~> 1.0"])
      s.add_dependency(%q<jeweler>, ["~> 2.0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<reek>, ["~> 1.2"])
      s.add_dependency(%q<roodi>, ["~> 2.1"])
      s.add_dependency(%q<shoulda>, ["~> 3.5"])
      s.add_dependency(%q<rubocop>, ["~> 0.32"])
      s.add_dependency(%q<simplecov>, ["~> 0.10"])
      s.add_dependency(%q<yard>, ["~> 0.7"])
    end
  else
    s.add_dependency(%q<activesupport>, ["~> 4.2"])
    s.add_dependency(%q<commander>, ["~> 4.3"])
    s.add_dependency(%q<json>, ["~> 1.8"])
    s.add_dependency(%q<rest-client>, ["~> 1.8"])
    s.add_dependency(%q<settingslogic>, ["~> 2.0"])
    s.add_dependency(%q<terminal-announce>, ["~> 1.0"])
    s.add_dependency(%q<nokogiri>, ["~> 1.6"])
    s.add_dependency(%q<bundler>, ["~> 1.0"])
    s.add_dependency(%q<jeweler>, ["~> 2.0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<reek>, ["~> 1.2"])
    s.add_dependency(%q<roodi>, ["~> 2.1"])
    s.add_dependency(%q<shoulda>, ["~> 3.5"])
    s.add_dependency(%q<rubocop>, ["~> 0.32"])
    s.add_dependency(%q<simplecov>, ["~> 0.10"])
    s.add_dependency(%q<yard>, ["~> 0.7"])
  end
end

