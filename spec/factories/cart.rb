FactoryGirl.define do

 sequence :product_code do |n|
  n.to_s.rjust(8)
 end
 factory  :cart, :class => CartItem do
  ignore do
   offers_count 3
  end
  product_name "Base"
  product_link { next(:product_code) }
  factory :cart_store do
   type 'CartStore'
   product_name "store"
   offer_params { {"price_qty" => (1..offers_count).inject([]){|r, i| r << {"min_qty" => i*100+50, "price" => 5.0-(i*0.5)} } } }
  end
  factory :cart_world do
   type "CartWorld"
   product_name "store"
  end
  after_build {|c| c.serialize_offer }
  after_build {|c| c.setup_price }
 end 

end
