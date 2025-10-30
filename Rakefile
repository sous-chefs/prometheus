require 'bundler/setup'
require 'cookstyle'
require 'rubocop/rake_task'
require 'kitchen'
require 'rspec/core/rake_task'

# Unit Tests. rspec/chefspec
RSpec::Core::RakeTask.new(:unit)

# Style tests. Rubocop
namespace :style do
  desc 'Run Ruby style checks'
  RuboCop::RakeTask.new(:ruby)
end

desc 'Run all style checks'
task style: ['style:ruby']

# Integration tests. Kitchen.ci
namespace :integration do
  desc 'Run Test Kitchen with Vagrant'
  task :vagrant do
    Kitchen.logger = Kitchen.default_file_logger
    Kitchen::Config.new.instances.each do |instance|
      instance.test(:always)
    end
  end
end

# We cannot run Test Kitchen on Travis CI yet...
namespace :travis do
  desc 'Run tests on Travis'
  task ci: %w(style unit)
end

# The default rake task should just run it all
task default: ['travis:ci', 'integration']
