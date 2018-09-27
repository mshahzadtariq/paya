# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'paya/version'

Gem::Specification.new do |spec|
  spec.name          = "paya"
  spec.version       = Paya::VERSION
  spec.authors       = ["Shahzad Tariq"]
  spec.email         = ["m.shahzad.tariq@hotmail.com"]

  spec.summary       = %q{Ruby wrapper for Paya ACH payment gateway integration}
  spec.description   = %q{Ruby wrapper for Paya ACH payment gateway integration. This is developed by reading Paya documentation and is not official team of Paya}
  spec.homepage      = "https://github.com/mshahzadtariq"
  spec.license       = "MIT"


  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "savon"
end
