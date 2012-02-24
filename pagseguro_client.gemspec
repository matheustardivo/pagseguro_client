# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "pagseguro_client/version"

Gem::Specification.new do |s|
  s.name        = "pagseguro_client"
  s.version     = PagseguroClient::VERSION
  s.authors     = ["Matheus Tardivo"]
  s.email       = ["matheustardivo@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{The new Pagseguro library to use with v2 services}
  s.description = s.summary

  s.rubyforge_project = "pagseguro_client"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency  "rspec-rails"  , "~> 2.7"
  s.add_development_dependency  "rails"        , "~> 3.2"
  s.add_development_dependency  "rake"         , "~> 0.9"
  s.add_development_dependency  "sqlite3"      , "~> 1.3"
  s.add_runtime_dependency      "nokogiri"     , "~> 1.5"
  s.add_runtime_dependency      "rest-client"  , "~> 1.6"
end
