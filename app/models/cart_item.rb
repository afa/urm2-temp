class CartItem < ActiveRecord::Base

 belongs_to :user
 scope :unprocessed, where(:processed => false)
 scope :in_cart, where(:draft => false)

 def type_name
  "Base"
 end
end
