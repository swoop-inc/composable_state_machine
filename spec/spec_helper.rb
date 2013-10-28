require 'simplecov'
SimpleCov.start
SimpleCov.minimum_coverage 100

require 'pp'

require 'composable_state_machine'

Dir['spec/support/**/*.rb'].each { |f| require File.expand_path(f) }
