FactoryGirl.define do

 factory  :cart, :class => CartItem do
  product_name "Base"

  factory :cart_store do
   type 'CartStore'
   product_name "store"
  end
 end 

end
