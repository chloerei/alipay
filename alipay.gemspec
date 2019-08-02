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

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "webmock"
end
