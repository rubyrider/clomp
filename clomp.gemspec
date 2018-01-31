
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "clomp/version"

Gem::Specification.new do |spec|
  spec.name          = "clomp"
  spec.version       = Clomp::VERSION
  spec.authors       = ['Irfan Ahmed']
  spec.email         = ['irfandhk@gmail.com', 'odesk.irfan@gmail.com']

  spec.summary       = %q{Clomp is a simple service builder for ruby using railway oriented programing paradigm.}
  spec.description   = %q{Clomp gem provides a smooth, lightweight, productive and reusable way to build an operation using Railway Oriented Programing paradigm.}
  spec.homepage      = "https://github.com/rubyrider/clomp"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "codeclimate-test-reporter"
  spec.add_development_dependency "rubocop"
end
