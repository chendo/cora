# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cora/version"

Gem::Specification.new do |s|
  s.name        = "cora"
  s.version     = Cora::VERSION
  s.authors     = ["Jack Chen (chendo)"]
  s.email       = ["@chendo"]
  s.homepage    = ""
  s.summary     = "Example summary"
  s.description = "Example description"

  s.rubyforge_project = "cora"

  s.add_development_dependency "rspec"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "rake"

  s.add_runtime_dependency "geocoder", "=1.1.6"

  s.files         = `git ls-files 2> /dev/null`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/* 2> /dev/null`.split("\n")
  s.executables   = `git ls-files -- bin/* 2> /dev/null`.split("\n").map{ |f| File.basename(f) }

  s.require_paths = ["lib"]
end
