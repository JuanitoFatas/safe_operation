# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "safe_operation/version"

Gem::Specification.new do |spec|
  spec.name          = "safe_operation"
  spec.version       = SafeOperation::VERSION
  spec.authors       = ["Juanito Fatas"]
  spec.email         = ["katehuang0320@gmail.com"]

  spec.summary       = %(Write safer code with SafeOperation.)
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/juanitofatas/safe_operation"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
