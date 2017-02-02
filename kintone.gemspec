# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kintone/version'

Gem::Specification.new do |spec|
  spec.name          = 'kintone'
  spec.version       = Kintone::VERSION
  spec.authors       = ['Rikiya Kawakami']
  spec.email         = ['ricky.k.yang@gmail.com']
  spec.summary       = 'kintone API client for Ruby.'
  spec.description   = 'kintone API client for Ruby.'
  spec.homepage      = 'https://github.com/jue58/kintone'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'faraday', '>=0.9.2'
  spec.add_runtime_dependency 'faraday_middleware', '>=0.10.0'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3'
  spec.add_development_dependency 'rubocop', '~> 0.44.1'
  spec.add_development_dependency 'webmock', '~> 1.18'
  spec.add_development_dependency 'rspec-parameterized', '~> 0.1.2'
  spec.add_development_dependency 'coveralls'
end
