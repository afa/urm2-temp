set :application, "urm"
set :repository,  "git://staging.rbagroup.ru/urm2.git"

set :scm, :git
set :deploy_via, :export
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "staging.rbagroup.ru"                          # Your HTTP server, Apache/etc
role :app, "staging.rbagroup.ru"                          # This may be the same as your `Web` server
role :db,  "staging.rbagroup.ru", :primary => true # This is where Rails migrations will run

desc "stage params"
task :stage, :roles => :app do
 set :ssh_options, { :forward_agent => true }
 set :user, "afa"
 set :password, "massacre"
 set :use_sudo, true
 set :branch, "stage"
 set :migrate_env, "staging"
 set :rails_env, "staging"
 set :app_env, "staging"
 set :unicorn_env, "staging"
 set :deploy_to, "/mnt/data/www/urm_stage"
 set :current_path, File.join(deploy_to, current_dir)
 set :default_run_options, exists?(:default_run_options) ? fetch(:default_run_options).merge("RAILS_ENV" => "staging") : {"RAILS_ENV" => "staging"}
 set :unicorn_bin, "unicorn_rails"
 set :unicorn_pid, File.join(shared_path, "tmp/pids/unicorn.pid")
 ENV["RAILS_ENV"] = "staging"
end

desc "prod params"
task :prod, :roles => :app do
 set :ssh_options, { :forward_agent => true }
 set :user, "afa"
 set :password, "massacre"
 set :use_sudo, true
 set :branch, "master"
 set :migrate_env, "production"
 set :rails_env, "production"
 set :app_env, "production"
 set :unicorn_env, "production"
 set :deploy_to, "/mnt/data/www/urm2"
 set :current_path, File.join(deploy_to, current_dir)
 set :default_run_options, exists?(:default_run_options) ? fetch(:default_run_options).merge("RAILS_ENV" => "production") : {"RAILS_ENV" => "production"}
 set :unicorn_bin, "unicorn_rails"
 set :unicorn_pid, File.join(shared_path, "tmp/pids/unicorn.pid")
 ENV["RAILS_ENV"] = "production"
end

after "deploy:update_code", :copy_database_config

task :copy_database_config, :roles => :app do
 #run "ln -s #{shared_path}/log #{release_path}"
 run "chmod a+w #{release_path}/log"
 run "ln -s #{shared_path}/database.yml #{release_path}/config/database.yml"
 run "ln -fs #{shared_path}/tmp/pids #{release_path}/tmp"
 run "cd #{release_path} && bundle install"
 run "mkdir -pm a+w #{%w(images javascripts stylesheets).each{|s| "#{release_path}/public/#{s}" }.join(' ')}"
 #run "cd #{release_path} && RAILS_ENV=staging bundle exec rake assets:precompile"
end


require 'capistrano-unicorn'
load "deploy/assets"
namespace :unicorn do
 desc 'Restart Unicorn'
 task :restart, :roles => :app, :except => {:no_release => true} do
  pid = unicorn_get_pid
  unless pid.nil?
   logger.important("Restarting...", "Unicorn")
   stop
  end
  start
 end
end
#require "bundler/capistrano"
#require "capistrano/recipes"
#namespace :deploy do
# desc "start"
# task :start, :roles => :app do
#  run "cd #{release_path} && bundle exec unicorn_rails -Dc config/unicorn.rb"
# end
# desc "stop"
# task :stop, :roles => :app do
#  run "[ -f #{release_path}/tmp/pids/unicorn.pid ] && kill -QUIT `cat #{release_path}/tmp/pids/unicorn.pid`"
# end
# desc "restart"
# task :restart, :roles => :app do
#  run "[ -f #{release_path}/tmp/pids/unicorn.pid ] && kill -USR2 `cat #{release_path}/tmp/pids/unicorn.pid` || (cd #{release_path}&& unicorn_rails -Dc config/unicorn.rb)"
# end
#end
# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
