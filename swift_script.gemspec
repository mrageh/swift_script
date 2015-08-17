# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'swift_script/version'

Gem::Specification.new do |spec|
  spec.name          = "swift_script"
  spec.version       = SwiftScript::VERSION
  spec.authors       = ["Adam89"]
  spec.email         = ["adam.dev89@gmail.com"]
  spec.summary       = %q{A simple dyanmic language from create your own programming language}
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.5"
  spec.add_development_dependency "pry-byebug", "~> 3.1"
  spec.add_runtime_dependency "racc", "~> 1.4"
end
