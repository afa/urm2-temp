FactoryGirl.define do

 sequence :product_code do |n|
  n.to_s.rjust(8)
 end
 factory  :cart, :class => CartItem do
  product_name "Base"
  product_link { next(:product_code) }
  factory :cart_store do
   type 'CartStore'
   product_name "store"
  end
  factory :cart_world do
   type "CartWorld"
   product_name "store"
  end
 end 

end
