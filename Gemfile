#coding: UTF-8
source 'http://rubygems.org'

gem 'rails', '3.2.11'
#gem 'rails', '3.0.11'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem "sass", "~>3.1"
gem 'sass-rails', "~>3.2"
group :assets do
 gem 'coffee-rails'
 gem 'uglifier'
end

gem "uniform_notifier", "1.0.1"
gem 'pg'
#gem "carpentry"
gem "newrelic_rpm"

# Use unicorn as the web server
gem 'unicorn'
gem "haml-rails"
#gem "sass"
gem "jquery-rails"
#gem "clearance"
gem "cells"

gem "json_pure"
# Deploy with Capistrano
gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19', :require => 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

gem "rb-readline"
# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
gem "airbrake" #, :group => [:development, :production]
#gem "airbrake", :group => [:development, :production]
gem "bullet", :group => :development
gem "gon"
gem "spreadsheet", "=0.7.6"
#gem "gon", :git => 'git://github.com/afa/gon.git', :branch => "script_tag"
#gem "sqlite3", :group => :test
gem "rails-backbone"
group :development, :test, :staging do
 gem "capistrano-unicorn"
 gem "konacha"
 gem "sprockets"
 gem "ejs"
 gem "rspec", "~>2.11"
 gem "rspec-rails", "~>2.11"
# gem "cucumber", "1.0.6"
# gem "cucumber-rails"
 gem "factory_girl_rails", "~>1.4.0"
 gem "rspec-cells", "~>0.1"
 #gem "rcov"
 gem "simplecov"
 #gem "jasmine"
 gem "jasmine-headless-webkit"
 #gem "mustang"
 gem "headless"
 gem "execjs"
 gem "libv8", "=3.3.10.4"
 gem "therubyracer-freebsd"
 #gem "therubyracer"
 #gem "capybara"
 #gem "selenium-webdriver"
# gem 'webrat'
end

group :test do
 gem "database_cleaner"
end
