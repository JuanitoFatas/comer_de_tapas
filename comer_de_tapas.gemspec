# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "comer_de_tapas/version"

Gem::Specification.new do |spec|
  spec.name          = "comer_de_tapas"
  spec.version       = ComerDeTapas::VERSION
  spec.authors       = ["Juanito Fatas"]
  spec.email         = ["katehuang0320@gmail.com"]
  spec.summary       = %q{Ruby Tapas Episode Downloader.}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/juanitofatas/comer_de_tapas"
  spec.license       = "MIT"

  spec.files = %w[CONTRIBUTING.md DEVELOPMENT.md LICENSE README.md Rakefile comer_de_tapas.gemspec]
  spec.files += Dir.glob("lib/**/*.rb")
  spec.files += Dir.glob("bin/**/*")
  spec.files += Dir.glob("test/**/*")

  spec.executables   = ["comer_de_tapas"]
  spec.test_files    = Dir.glob("test/**/*")
  spec.require_paths = ["lib"]

  spec.add_dependency "thor"
  spec.add_dependency "http", ">= 0.6"
  spec.add_dependency "nokogiri"
  spec.add_dependency "celluloid-io"
end
