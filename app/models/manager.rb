class Manager < ActiveRecord::Base
 include Afauth::Model
 authen_field_name :name
 
 validates_uniqueness_of :name
 attr_accessor :password
 before_validation :reset_remember_token!, :if => lambda{ self.remember_token.blank? }

  def update_password(new_password)
   self.password_changing = true
   self.password          = new_password
   if valid?
    self.confirmation_token = nil
    generate_remember_token
   end
   save
  end
end
