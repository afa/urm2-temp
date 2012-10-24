# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'
require "rspec/rails"

Urm::Application.load_tasks
desc 'Run factory specs.'
RSpec::Core::RakeTask.new(:factory_specs) do |t|
  t.pattern = './spec/factories_spec.rb'
end

task spec: :factory_specs

#Cucumber::Rake::Task.new do |t|
# #t.rcov = true
#end
