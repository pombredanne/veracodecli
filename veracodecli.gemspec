# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: veracodecli 0.1.0 ruby lib lib/veracodecli

Gem::Specification.new do |s|
  s.name = "veracodecli"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib", "lib/veracodecli"]
  s.authors = ["isaiah thiessen"]
  s.date = "2015-09-21"
  s.description = "Ruby based CLI for accessing veracode's api"
  s.email = "isaiah.thiessen@telus.com"
  s.executables = ["veracodecli"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    "bin/veracodecli",
    "lib/veracodecli/api.rb"
  ]
  s.homepage = "http://github.com/isand3r/veracodecli"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.6"
  s.summary = "Ruby based CLI for accessing veracode's api"
  s.test_files = ["test/API.rb", "test/helper.rb", "test/test_veracodecli.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_runtime_dependency(%q<rest-client>, [">= 0"])
      s.add_runtime_dependency(%q<commander>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<yard>, ["~> 0.7"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 2.0.1"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
      s.add_development_dependency(%q<reek>, ["~> 1.2.8"])
      s.add_development_dependency(%q<roodi>, ["~> 2.1.0"])
    else
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<rest-client>, [">= 0"])
      s.add_dependency(%q<commander>, [">= 0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<yard>, ["~> 0.7"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, ["~> 1.0"])
      s.add_dependency(%q<jeweler>, ["~> 2.0.1"])
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<reek>, ["~> 1.2.8"])
      s.add_dependency(%q<roodi>, ["~> 2.1.0"])
    end
  else
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<rest-client>, [">= 0"])
    s.add_dependency(%q<commander>, [">= 0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<yard>, ["~> 0.7"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, ["~> 1.0"])
    s.add_dependency(%q<jeweler>, ["~> 2.0.1"])
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<reek>, ["~> 1.2.8"])
    s.add_dependency(%q<roodi>, ["~> 2.1.0"])
  end
end

