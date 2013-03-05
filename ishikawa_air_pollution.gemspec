# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ishikawa_air_pollution/version'

Gem::Specification.new do |spec|
  spec.name          = "ishikawa_air_pollution"
  spec.version       = IshikawaAirPollution::VERSION
  spec.authors       = ["Keisuke KITA"]
  spec.email         = ["kei.kita2501@gmail.com"]
  spec.description   = %q{Fetch the observed value of air pollutants in Ishikawa pref}
  spec.summary       = %q{Fetch the observed value of air pollutants in Ishikawa pref}
  spec.homepage      = "https://github.com/kitak/ishikawa_air_pollution"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'mechanize'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
