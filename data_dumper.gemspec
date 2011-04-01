# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "data_dumper/version"

Gem::Specification.new do |s|
  s.name        = "data_dumper"
  s.version     = DataDumper::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["François Beausoleil"]
  s.email       = ["francois@teksol.info"]
  s.homepage    = "https://github.com/francois/data_dumper"
  s.summary     = %q{Quick and dirty tool to dump data from an active test session to a development server}
  s.description = %q{From within your tests, if you can't understand what's going on, maybe you need to dump your data to your development database and use it from there?}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'activerecord', '>= 2.3'
end
