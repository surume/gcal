# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gcal/version'

Gem::Specification.new do |spec|
  spec.name          = "gcal"
  spec.version       = Gcal::VERSION
  spec.authors       = ["Surume"]
  spec.email         = ["surume0227@gmail.com"]
  spec.summary       = %q{get GoogleCalendar List}
  spec.description   = %q{get GoogleCalendar List}
  spec.homepage      = "https://github.com/Surume/gcal"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
