# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alipay/version'

Gem::Specification.new do |spec|
  spec.name          = "alipay"
  spec.version       = Alipay::VERSION
  spec.authors       = ["Rei"]
  spec.email         = ["chloerei@gmail.com"]
  spec.description   = %q{An unofficial simple alipay gem}
  spec.summary       = %q{An unofficial simple alipay gem}
  spec.homepage      = "https://github.com/chloerei/alipay"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "webmock"
end
