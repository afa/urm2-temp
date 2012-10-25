class Setting < ActiveRecord::Base
 require "yaml"
 belongs_to :settingable, :polymorphic => true
 scope :by_user, lambda {|u_id| where(:user_id => u_id) }
 scope :by_name, lambda {|nm| where(:name => nm) }
  def self.load_default
   File.open(File.join(Rails.root, "config", "settings.yaml"), 'r') do |f|
    @@defaults = YAML::load(f)
   end
  end
  load_default

  def self.or_default(name)
   @@defaults[name]
  end
end
