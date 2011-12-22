class Enumeration < ActiveRecord::Base

 serialize :values, Array

  def self.load_source
   AxaptaRequest.describe_methods("id"=>rand(10**6))
  end

  def self.renew_enums
   config = self.load_source
   config["enums"].each do |k, v|
    loc = self.where(:name => k).first
    loc = self.new(:name => k) unless loc
    loc.values = v
    loc.save!
   end
  end


end
