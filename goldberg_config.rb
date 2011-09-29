#Goldberg configuration
  Project.configure do |config|
    config.frequency = 20
    #config.ruby = '1.8.7' # Your server needs to have rvm installed for this setting to be considered
    #config.environment_variables = {"FOO" => "bar"}
    #config.after_build Proc.new { |build, project| `touch ~/Desktop/actually_built`}
    config.environment_variables = {"RAILS_ENV" => "test"}
    config.timeout = 10.minutes
    config.command = 'RAILS_ENV=test rake db:migrate&&RAILS_ENV=test rake spec' #to be used if you're using anything other than rake
  end

