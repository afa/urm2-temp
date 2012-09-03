class Account < ActiveRecord::Base
 belongs_to :user
 belongs_to :parent, :class_name => self.name, :foreign_key => :parent_id
 has_many :children, :class_name => self.name, :foreign_key => :parent_id

  def self.axapta_attributes
   %w(blocked business empl_name empl_email contact_first_name contact_last_name contact_middle_name axapta_user_id axapta_parent_id contact_email name cust_account invent_location_id department)
  end

  def self.axapta_renames
   {"user_id" => "axapta_user_id", "parent_user_id" => "axapta_parent_id", "user_name" => "name"}
  end

  def self.filter_account_attributes(args)
   args.inject({}){|r, a| r.merge(axapta_renames[a[0]].nil? ? {a[0] => a[1]}: {axapta_renames[a[0]] => a[1]}) }.delete_if{|k, v| not axapta_attributes.include?(k.to_s) }
  end

  def human_readable
   [department, cust_account].compact.join(' ')
  end
end
