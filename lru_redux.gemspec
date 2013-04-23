# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lru_redux/version'

Gem::Specification.new do |spec|
  spec.name          = "lru_redux"
  spec.version       = LruRedux::VERSION
  spec.authors       = ["Sam Saffron"]
  spec.email         = ["sam.saffron@gmail.com"]
  spec.description   = %q{An efficient implementation of an lru cache}
  spec.summary       = %q{An efficient implementation of an lru cache}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "guard-minitest"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "rb-inotify"
end
