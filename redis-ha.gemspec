# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redis_ha/version'

Gem::Specification.new do |spec|
  spec.name          = "redis-ha"
  spec.version       = RedisHA::VERSION
  spec.authors       = ["John Maxwell"]
  spec.email         = ["john@musicglue.com"]
  spec.description   = %q{RedisHA is an attempt at a highly available Redis Installation}
  spec.summary       = %q{See Description}
  spec.homepage      = "http://musicglue.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "eventmachine"
  spec.add_dependency "activesupport"
end
