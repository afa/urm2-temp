source 'http://rubygems.org'

gem 'rails', '3.0.11'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'
gem "carpentry"
gem "newrelic_rpm"

# Use unicorn as the web server
gem 'unicorn'
gem "haml-rails"
gem "sass"
gem "jquery-rails"
#gem "clearance"
gem "cells"

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19', :require => 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
gem "airbrake", :group => [:development, :production]
gem "bullet", :group => :development
#gem "sqlite3", :group => :test
group :development, :test do
 gem "rspec-rails"
 gem "cucumber-rails"
 gem "factory_girl_rails", "~>1.3"
 gem "rspec-cells"
 gem "rcov"
 #gem "jasmine"
 gem "jasmine-headless-webkit"
 gem "mustang"
 gem "headless"
 #gem "execjs"
 #gem "capybara"
 #gem "selenium-webdriver"
# gem 'webrat'
end

group :test do
 gem "database_cleaner"
end
