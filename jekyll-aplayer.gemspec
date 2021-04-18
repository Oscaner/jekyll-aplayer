# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jekyll-aplayer/version"

Gem::Specification.new do |spec|
  spec.name          = "jekyll-aplayer"
  spec.version       = Jekyll::Aplayer::VERSION
  spec.authors       = ["Oscaner"]
  spec.email         = "oscaner1997@github.com"
  spec.summary       = "HTML5-flavored aplayer plugin for Jekyll"
  spec.homepage      = "https://github.com/Oscaner/jekyll-aplayer"
  spec.licenses      = ["MIT"]

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.4.0"

  spec.add_dependency "jekyll", ">= 3.0", "< 5.0"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop-jekyll", "~> 0.4"
end
