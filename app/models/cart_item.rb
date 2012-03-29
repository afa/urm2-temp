class CartItem < ActiveRecord::Base
 class CartParamRequired < StandardError; end
 belongs_to :user
 scope :unprocessed, where(:processed => false)
 scope :in_cart, where("amount > 0")
 #scope :in_cart, where(:draft => false)
 ATTR_KEYS = %w(amount product_link location_link product_name product_rohs product_brend processed order current_price prognosis quantity min_amount max_amount comment user_price actions draft offer_params offer_serialized reserve pick requirement line offer_code line_code).map(&:to_sym)

 attr_accessor :allow, :line, :offer_code, :line_code
 attr_accessor :offer_params

 before_validation :setup_price
 after_initialize :deserialize_offer
 before_validation :serialize_offer

  def action

  end

  def action=(str)

  end

  def to_hash
   ATTR_KEYS.map{|k| [k, send(k)] }.inject({}){|r, v| r.merge(v[0] => v[1]) }
  end

  def deserialize_offer
   self.offer_params = self.offer_serialized.blank? ? {} : YAML::load(self.offer_serialized)
  end

  def serialize_offer
   self.offer_serialized = self.offer_params.to_yaml
  end


  def setup_price
   self.max_amount ||= 0
   self.min_amount ||= 0

   if self.amount and self.amount > 0
    self.amount = self.min_amount if self.amount < self.min_amount
    if self.offer_params && self.offer_params["price_qty"]
     self.current_price = (self.offer_params["price_qty"] || []).sort_by{|i| i["min_qty"].to_i }.reject{|i| i["min_qty"].to_i > self.amount }.last.try(:[], "price").try(:to_f) || 0.0
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
   {:item_id => self.product_link, :item_name => self.product_name, :note => self.comment, :qty => self.amount, :invc_brend_alias => self.product_brend, :requirement => self.requirement}
  end

  def self.copy_on_write(hsh) # excpshn on bad params, not found
   raise CartParamRequired unless hsh.try(:[], :cart)
   old = CartItem.find_by_id(hsh[:cart])
   raise CartParamRequired unless old
   puts "ammount #{hsh[:amount]} => #{old.amount}"
   new_hsh = old.to_hash
   new_hsh[:amount] = hsh[:amount].to_i
   ntype = old.setup_for(new_hsh)
   n = ntype.create(new_hsh.update(:user_id => User.current.id))
   old.destroy
   n
   n.id
   
  end
end
