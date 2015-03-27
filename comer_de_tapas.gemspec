# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'comer_de_tapas/version'

Gem::Specification.new do |spec|
  spec.name          = 'comer_de_tapas'
  spec.authors       = ['Juanito Fatas']
  spec.email         = ['katehuang0320@gmail.com']

  spec.homepage      = 'https://github.com/juanitofatas/comer_de_tapas'
  spec.summary       = %q{Ruby Tapas Episode Downloader.}
  spec.description   = spec.summary
  spec.license       = 'MIT'

  spec.files = %w[CONTRIBUTING.md DEVELOPMENT.md LICENSE README.md Rakefile comer_de_tapas.gemspec] + Dir['bin/*']  + Dir['lib/**/*.rb']
  spec.executables   = ['comer_de_tapas']
  spec.require_paths = %w(lib)

  spec.version       = ComerDeTapas::VERSION

  spec.required_ruby_version     = '>= 2.0.0'
  spec.required_rubygems_version = '>= 2.2.2'

  spec.add_dependency 'thor'
  spec.add_dependency 'http', '>= 0.7.3'
  spec.add_dependency 'nokogiri'
  spec.add_dependency 'celluloid-io'
end
