# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'primetable/version'

Gem::Specification.new do |spec|
  spec.name          = "primetable"
  spec.version       = PrimeTable::VERSION
  spec.authors       = ["Day Davis Waterbury"]
  spec.email         = ["day.waterbury@gmail.com"]
  spec.summary       = %q{Prints a multiplication table of N primes to STDOUT}
  spec.description   = %q{Displays the products of N primes in a table format. Optionally uses generated primes or precalculated.}
  spec.homepage      = "https://github.com/day/primetable"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'therubyracer', '~> 0.12', '>= 0.12.2'
  spec.add_runtime_dependency 'formatador', '~> 0.2', '>= 0.2.5'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", '~> 10.4', '>= 10.4.2'
  spec.add_development_dependency "rspec", '~> 3.4', '>= 3.4.0'
  spec.add_development_dependency "pry"
end
