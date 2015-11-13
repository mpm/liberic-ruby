# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'liberic/version'

Gem::Specification.new do |spec|
  spec.name          = "liberic"
  spec.version       = Liberic::VERSION
  spec.authors       = ["Malte Münchert"]
  spec.email         = ["malte.muenchert@gmx.net"]

  spec.summary       = %q{Ruby bindings for ELSTER/ERiC (German Tax Authority Service)}
  spec.description   = %q{Liberic is a ruby wrapper for ERiC, a C library to interact with German Tax Authority's ELSTER service.}
  spec.homepage      = "https://www.github.com/mpm/liberic-ruby"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  #if spec.respond_to?(:metadata)
    #spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  #else
    #raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  #end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "ffi", "~> 1.9"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 1.9"
end
