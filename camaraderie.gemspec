# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'camaraderie/version'

Gem::Specification.new do |spec|
  spec.name          = 'camaraderie'
  spec.version       = Camaraderie::VERSION
  spec.authors       = ['Rémi Prévost']
  spec.email         = ['rprevost@mirego.com']
  spec.description   = 'Camaraderie takes away the pain of managing membership stuff between users and organizations.'
  spec.summary       = 'Camaraderie takes away the pain of managing membership stuff between users and organizations.'
  spec.homepage      = 'https://github.com/mirego/camaraderie'
  spec.license       = 'BSD 3-Clause'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'

  spec.add_dependency 'activerecord', '>= 3.0.0'
  spec.add_dependency 'activesupport', '>= 3.0.0'
end
