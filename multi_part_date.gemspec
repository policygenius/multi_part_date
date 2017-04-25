# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'multi_part_date/version'

Gem::Specification.new do |spec|
  spec.name          = "multi_part_date"
  spec.version       = MultiPartDate::VERSION
  spec.authors       = ["Petr Gazarov"]
  spec.email         = ["petrgazarov@gmail.com"]

  spec.summary       = %q{Splitting date field into multiple inputs on the form object level (reform)}
  spec.homepage      = "https://github.com/policygenius/multi_part_date"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "reform", "~> 2.2.4"
  spec.add_runtime_dependency "virtus", "~> 1.0.1"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
end
