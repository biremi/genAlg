# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "genAlg/version"

Gem::Specification.new do |s|
  s.name        = "genAlg"
  s.version     = GenAlg::VERSION
  s.authors     = ["Roman Bilous"]
  s.email       = ["romanrpd@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Genetic algorithms 4 Ruby}
  s.description = %q{Use genetic algorithms in your ruby projects. More coming here}

  s.rubyforge_project = "genAlg"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
