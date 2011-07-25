class Account < ActiveRecord::Base
 belongs_to :user
 belongs_to :parent, :class_name => self.name, :foreign_key => :parent_id
 has_many :children, :class_name => self.name, :foreign_key => :parent_id
end
