class Setting < ActiveRecord::Base
 require "yaml"
 belongs_to :settingable, :polymorphic => true
  def self.load_default
   File.open(File.join(Rails.root, "config", "settings.yaml"), 'r') do |f|
    @@defaults = YAML::load(f)
   end
  end
  load_default
end
