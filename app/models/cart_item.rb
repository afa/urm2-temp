class CartItem < ActiveRecord::Base

 scope :unprocessed, where(:processed => false)

end
