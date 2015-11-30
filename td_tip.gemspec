# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'td_tip/version'

Gem::Specification.new do |spec|
  spec.name          = 'td_tip'
  spec.version       = TdTip::VERSION
  spec.authors       = ['Wiesław Spyra']
  spec.email         = ['wmms@o2.pl']

  spec.summary       = 'T+D Code challenge'
  spec.description   = 'T+D Code challenge solution'
  spec.homepage      = 'https://github.com/wspyra/td_tip'
  spec.license       = 'MIT'

  spec.bindir        = 'bin'
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'coveralls', '~> 0.8.10'
  spec.add_development_dependency 'rubocop', '~> 0.35.1'

  spec.add_dependency 'thor', '~> 0.19.1'
  spec.add_dependency 'httparty', '~> 0.13.7'
  spec.add_dependency 'activemodel', '~> 4.2'
end
