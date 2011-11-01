class CartItem < ActiveRecord::Base

 belongs_to :user
 scope :unprocessed, where(:processed => false)

 def type_name
  "Base"
 end
end
