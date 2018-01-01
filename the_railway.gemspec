
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "the_railway/version"

Gem::Specification.new do |spec|
  spec.name          = "the_railway"
  spec.version       = TheRailway::VERSION
  spec.authors       = ["Irfan"]
  spec.email         = ["irfandhk@gmail.com"]

  spec.summary       = %q{Simple operation builder.}
  spec.description   = %q{The Railway gem provides a smooth, lightweight, productive and reusable way to build an operation using Railway oriented programing paradigm.}
  spec.homepage      = "https://github.com/rubyrider/the_railway"
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
end
