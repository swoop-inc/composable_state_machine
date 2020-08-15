# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'composable_state_machine/version'

Gem::Specification.new do |spec|
  spec.name          = 'composable_state_machine'
  spec.version       = ComposableStateMachine::VERSION
  spec.authors       = ['Simeon Simeonov']
  spec.email         = ['sim@swoop.com']
  spec.description   = %q{Small, fast and flexible state machines using composition.}
  spec.summary       = %q{The composition patterns in this implementation make it easy to circumvent the limitations of other state machine gems. A single state machine model can be shared across thousands of machine instances without the usual overhead. An object can have more than one state machine. States and events can be any objects, not just strings or symbols. Events can take optional parameters. Different state machine models can fire different types of callbacks. Adding new types of callbacks takes a couple of lines of code. Explicit callback runners enable easy decoration for logging, caching or other purposes. No external dependencies and 100% code coverage.}
  spec.homepage      = 'https://github.com/swoop-inc/composable_state_machine'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib)

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'redcarpet'

  if RUBY_PLATFORM =~ /darwin/ && RUBY_VERSION =~ /^2/
    spec.add_development_dependency 'guard'
    spec.add_development_dependency 'guard-rspec'
    spec.add_development_dependency 'growl'
  end
end
