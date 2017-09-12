# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "himekami/markdown/version"

Gem::Specification.new do |spec|
  spec.name          = "himekami-markdown"
  spec.version       = Himekami::Markdown::VERSION
  spec.authors       = ["otukutun"]
  spec.email         = ["orehaorz@gmail.com"]

  spec.summary       = %q{Project himekami markdown parser.}
  spec.description   = %q{Project himekami markdown parser.}
  spec.homepage      = "https://github.com/otukutun/himekami-markdown"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "bundler", "~> 1.15"
  spec.add_dependency 'activesupport', '~> 5.1'
  spec.add_dependency "html-pipeline", "~> 2.6"
  spec.add_dependency "commonmarker", "~> 0.14"
  spec.add_dependency 'github-linguist', '~> 5.2'
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'rspec_junit_formatter', '~> 0.3.0'
  spec.add_development_dependency 'pry', '~> 0'
end
