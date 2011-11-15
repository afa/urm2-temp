class CartItem < ActiveRecord::Base
 class CartParamRequired < StandardError; end
 belongs_to :user
 scope :unprocessed, where(:processed => false)
 scope :in_cart, where(:draft => false)

 attr_accessor :allow

  def type_name
   "Base"
  end

  def offers(count) #ret hash product
   raise "NYI"
  end

  def self.prepare_for(count, hsh)
   raise "NYI"
  end

  def self.copy_on_write(hsh) # excpshn on bad params, not found
   raise CartParamRequired unless hsh.try(:[], :cart)
   old = find_by_id(hsh[:cart])
   raise CartParamRequired unless old
   if hsh[:amount].to_i != old.amount
    puts "ammount #{hsh[:amount]}"
    offers = old ? old.offers(hsh[:amount].to_i) : []
    new_hsh = old.class.prepare_for(hsh[:amount].to_i, offers.first)# || {"item_id" =>old.product_link, "locations" => [{"location_id" => old.location_link, "price_qty" => {"price" => old.current_price}, "vend_qty" => old.max_amount}], "item_name" => old.product_name, "rohs" => old.product_rohs, "item_brend" => old.product_brend, "qty_in_pack" => old.quantity, "min_qty" => old.min_amount})
    #new_hsh = old.class.prepare_for(hsh[:amount].to_i, offers.first || {"item_id" =>old.product_link, "locations" => [{"location_id" => old.location_link, "price_qty" => {"price" => old.current_price}, "vend_qty" => old.max_amount}], "item_name" => old.product_name, "rohs" => old.product_rohs, "item_brend" => old.product_brend, "qty_in_pack" => old.quantity, "min_qty" => old.min_amount})
    instance_eval(new_hsh[:type]).create(new_hsh.reject{|k, v| k == :type }.update(:draft => !(new_hsh[:amount].to_i > 0), :user_id => User.current.id))
    old.destroy
   end
   
  end
end
=begin
:type => self.name, :amount => count, :product_link => hsh["item_id"], :location_link => hsh["locations"].first["location_id"], :product_name => hsh["item_name"], :product_rohs => hsh["rohs"], :product_brend => hsh["item_brend"], :processed => false, :current_price => selected["price"], :quantity => hsh["qty_in_pack"], :min_amount => hsh["min_qty"], :max_amount => hsh["locations"].first["vend_qty"], :avail_amount => hsh["locations"].first["vend_qty"], :draft => !(count > 0)
=end
