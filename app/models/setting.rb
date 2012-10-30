class Setting < ActiveRecord::Base
 require "yaml"
 belongs_to :settingable, :polymorphic => true
 scope :by_user, lambda {|u_id| where(:settingable_id => u_id, :settingable_type => 'User') }
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

  def self.get(name)
   (by_user(User.current.id).by_name(name).first || by_user(nil).by_name(name)).try(:value) || or_default(name)
  end

  def self.set_all(hsh)
   hsh.each do |k, v|
    (Setting.by_user(User.current_user.id).by_name(k).first || Setting.by_user(User.current_user.id).by_name(k).create).update_attribute :value, v
   end
  end
end
