class CartItem < ActiveRecord::Base
 class CartParamRequired < StandardError; end
 belongs_to :user
 scope :unprocessed, where(:processed => false)
 scope :in_cart, where("amount > 0")
 #scope :in_cart, where(:draft => false)
 ATTR_KEYS = %w(amount product_link location_link product_name product_rohs product_brend processed order current_price prognosis quantity min_amount max_amount comment user_price actions draft offer_params offer_serialized reserve pick).map(&:to_sym)

 attr_accessor :allow
 attr_accessor :offer_params

 before_validation :setup_price
 after_initialize :deserialize_offer
 before_validation :serialize_offer

  def to_hash
   ATTR_KEYS.map{|k| [k, send(k)] }.inject({}){|r, v| r.merge(v[0] => v[1]) }
  end

  def deserialize_offer
   p "==deserialize #{self.type}##{self.id}", self.offer_serialized
   self.offer_params = self.offer_serialized.blank? ? {} : YAML::load(self.offer_serialized)
  end

  def serialize_offer
   p "==serialize #{self.type}##{self.id}", self.offer_params
   self.offer_serialized = self.offer_params.to_yaml
  end


  def setup_price
   self.max_amount ||= 0
   self.min_amount ||= 0

   if self.amount and self.amount > 0
    #self.amount = self.max_amount if self.amount > self.max_amount
    self.amount = self.min_amount if self.amount < self.min_amount
    if self.offer_params.try(:[], "price_qty")
     self.current_price = self.offer_params["price_qty"].sort_by{|i| i["min_qty"].to_i }.reject{|i| i["min_qty"].to_i > self.amount }.last["price"].to_f
    else
     self.current_price = 0
    end
   else
    self.current_price = 0
   end
  end


  def type_name
   "Base"
  end

  def offers(count) #ret hash product
   raise "NYI"
  end

  def self.prepare_for(count, hsh)
   raise "NYI"
  end

  def to_sales_lines
   {:item_id => self.product_link, :item_name => self.product_name, :note => self.comment, :qty => self.amount, :invc_brend_alias => self.product_brend}
  end

  def self.copy_on_write(hsh) # excpshn on bad params, not found
   raise CartParamRequired unless hsh.try(:[], :cart)
   old = find_by_id(hsh[:cart])
   raise CartParamRequired unless old
   #need_copy = {:user_price => old.user_price, :comment => old.comment, :actions => old.actions, :offer_params => old.offer_params}
   #if hsh[:amount].to_i != old.amount
   puts "ammount #{hsh[:amount]} => #{old.amount}"
   #offers = old.offers(hsh[:amount].to_i)
   new_hsh = old.to_hash
   new_hsh[:amount] = hsh[:amount].to_i
   ntype = old.setup_for(new_hsh)
   #new_ = old.is_a?(CartWorld) ? old.class.prepare_for(hsh[:amount].to_i, offers.first, old) : old.class.prepare_for(hsh[:amount].to_i, offers.first)
     # || {"item_id" =>old.product_link, "locations" => [{"location_id" => old.location_link, "price_qty" => {"price" => old.current_price}, "vend_qty" => old.max_amount}], "item_name" => old.product_name, "rohs" => old.product_rohs, "item_brend" => old.product_brend, "qty_in_pack" => old.quantity, "min_qty" => old.min_amount})
   #new_hsh = old.class.prepare_for(hsh[:amount].to_i, offers.first || {"item_id" =>old.product_link, "locations" => [{"location_id" => old.location_link, "price_qty" => {"price" => old.current_price}, "vend_qty" => old.max_amount}], "item_name" => old.product_name, "rohs" => old.product_rohs, "item_brend" => old.product_brend, "qty_in_pack" => old.quantity, "min_qty" => old.min_amount})
   #instance_eval(new_hsh[:type]).create(new_hsh.update(:draft => !(new_hsh[:amount].to_i > 0), :user_id => User.current.id))
   n = ntype.create(new_hsh.update(:user_id => User.current.id))
   old.destroy
   n
   #end
   
  end
end
