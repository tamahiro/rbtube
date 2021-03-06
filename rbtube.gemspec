# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rbtube/version'

Gem::Specification.new do |spec|
  spec.name          = 'rbtube'
  spec.version       = Rbtube::VERSION
  spec.authors       = %w(tamahiro)
  spec.email         = %w(tmkshrnr@gmail.com)
  spec.summary       = 'A Ruby Library for downloading Youtube videos'
  spec.description   = 'A Ruby Library for downloading Youtube videos'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib)

  spec.add_development_dependency('bundler', '~> 1.7')
  spec.add_development_dependency('rake', '~> 10.0')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('simplecov')
  spec.add_development_dependency('guard')
  spec.add_development_dependency('guard-rspec')
  spec.add_development_dependency('terminal-notifier')
  spec.add_development_dependency('terminal-notifier-guard')
end
