$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'yaml/version'

Gem::Specification.new do |s|
  s.name        = 'yaml-sugar'
  s.version     = YamlSugar::VERSION
  s.summary     = 'Read yaml files into an OpenStruct'
  s.description = 'Read yaml files recursively from a given directory and return an OpenStruct'
  s.authors     = ['Daniel Han']
  s.email       = 'hex0cter@gmail.com'
  s.homepage    = 'https://github.com/hex0cter/yaml-sugar'
  s.license     = 'MIT'
  s.files         = Dir['lib/**/*']
  s.required_ruby_version = '>= 1.9.3'
  s.require_paths = ['lib']

  s.add_dependency 'hashugar', '~> 1.0'
  s.add_dependency 'deep_merge', '~> 1.0'
end
