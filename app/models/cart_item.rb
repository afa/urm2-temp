class CartItem < ActiveRecord::Base
 class CartParamRequired < StandardError; end
 belongs_to :user
 scope :unprocessed, where(:processed => false)
 scope :in_cart, where(:draft => false)

 attr_accessor :allow
 attr_accessor :offer_params

 after_initialize :deserialize_offer
 before_validation :serialize_offer

  def type_name
   "Base"
  end

  def offers(count) #ret hash product
   raise "NYI"
  end

  def self.prepare_for(count, hsh)
   raise "NYI"
  end

  def to_sales_line
   {:brend_alias => product_brend, :item_id => product_link, :item_name => product_name, :note => comment, :qty => amount, :invc_brend_alias => product_brend}
  end

  def self.copy_on_write(hsh) # excpshn on bad params, not found
   raise CartParamRequired unless hsh.try(:[], :cart)
   old = find_by_id(hsh[:cart])
   raise CartParamRequired unless old
   need_copy = {:user_price => old.user_price, :comment => old.comment, :actions => old.actions}
   if hsh[:amount].to_i != old.amount
    puts "ammount #{hsh[:amount]}"
    offers = old ? old.offers(hsh[:amount].to_i) : []
    new_hsh = old.is_a?(CartWorld) ? old.class.prepare_for(hsh[:amount].to_i, offers.first, old) : old.class.prepare_for(hsh[:amount].to_i, offers.first)
      # || {"item_id" =>old.product_link, "locations" => [{"location_id" => old.location_link, "price_qty" => {"price" => old.current_price}, "vend_qty" => old.max_amount}], "item_name" => old.product_name, "rohs" => old.product_rohs, "item_brend" => old.product_brend, "qty_in_pack" => old.quantity, "min_qty" => old.min_amount})
    #new_hsh = old.class.prepare_for(hsh[:amount].to_i, offers.first || {"item_id" =>old.product_link, "locations" => [{"location_id" => old.location_link, "price_qty" => {"price" => old.current_price}, "vend_qty" => old.max_amount}], "item_name" => old.product_name, "rohs" => old.product_rohs, "item_brend" => old.product_brend, "qty_in_pack" => old.quantity, "min_qty" => old.min_amount})
    instance_eval(new_hsh[:type]).create(new_hsh.reject{|k, v| k == :type }.update(:draft => !(new_hsh[:amount].to_i > 0), :user_id => User.current.id))
    old.destroy
   end
   
  end
end
=begin
:type => self.name, :amount => count, :product_link => hsh["item_id"], :location_link => hsh["locations"].first["location_id"], :product_name => hsh["item_name"], :product_rohs => hsh["rohs"], :product_brend => hsh["item_brend"], :processed => false, :current_price => selected["price"], :quantity => hsh["qty_in_pack"], :min_amount => hsh["min_qty"], :max_amount => hsh["locations"].first["vend_qty"], :avail_amount => hsh["locations"].first["vend_qty"], :draft => !(count > 0)
=end
