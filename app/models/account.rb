class Account < ActiveRecord::Base
 belongs_to :user
 belongs_to :parent, :class_name => self.name, :foreign_key => :parent_id
 has_many :children, :class_name => self.name, :foreign_key => :parent_id

  def self.axapta_attributes
   %w(blocked business empl_name empl_email contact_first_name contact_last_name contact_middle_name)
  end

end
