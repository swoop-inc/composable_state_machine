require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'yard'

desc 'Default: run the specs'
task :default do
  system('bundle exec rspec')
end

desc 'Run the specs'
task :spec => :default

desc 'Open an irb session preloaded with this library'
task :console do
  exec 'irb -rubygems -I lib -r composable_state_machine.rb'
end

YARD::Rake::YardocTask.new do |_|
end
