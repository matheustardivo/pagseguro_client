# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "pagseguro_client/version"

Gem::Specification.new do |s|
  s.name        = "pagseguro_client"
  s.version     = PagseguroClient::VERSION
  s.authors     = ["Matheus Tardivo", "Raphael Costa", "Andre Kupkovski", "Heitor Salazar Baldelli"]
  s.email       = ["matheustardivo@gmail.com", "raphael@raphaelcosta.net", "kupkovski@gmail.com", "heitor@woollu.com"]
  s.homepage    = "https://github.com/matheustardivo/pagseguro_client"
  s.summary     = %q{The library to access the new services from Pagseguro (v2)}
  s.description = s.summary
  s.license     = "MIT"

  s.rubyforge_project = "pagseguro_client"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "bundler"     , "~> 1.3"
  s.add_development_dependency "rake"        , "~> 10.1"
  s.add_development_dependency "rspec"       , "~> 2.13"
  s.add_development_dependency "rails"       , "~> 3.2"
  s.add_development_dependency "coveralls"   , "~> 0.6"
  s.add_runtime_dependency     "nokogiri"    , "~> 1.6"
  s.add_runtime_dependency     "rest-client" , "~> 1.6"
end
