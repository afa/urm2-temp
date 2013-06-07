class CartStore < CartItem

 @signature_fields = @base_signature_fields + [:location_link]
  before_validation :set_defaults, :on => :create

  def set_defaults
   if pick.nil? && reserve.nil?
    reserve = true
   end
  end

  def action
   return "pick" if self.pick?
   return "reserve" if self.reserve?
   return "order"
  end

  def action=(str)
   case str
    when "pick"
     self.pick = true
     self.reserve = false
    when "reserve"
     self.pick = false
     self.reserve = true
    else
     self.pick = false
     self.reserve = false
   end
  end

  def type_name
   ::I18n::t :cart_store
  end

  def allowed_actions
   %w(order reserve pick)
  end

  def to_sales_lines
   init = super.merge(:invent_location => location_link, :is_pick => self.pick?, :reserve_sale => self.reserve?, :application_area_id => self.application_area_id)
   self.user_price.blank? ? init : init.merge(:sales_price => self.user_price)
  end

  def self.prepare_code(search) #on find, chg search hash to offers array
   hsh = {:user_id => User.current.id, :product_link => search.code, :product_name => search.name, :product_rohs => search.rohs, :product_brend => search.brend, :location_link => search.location_id}
   fnd = CartItem.unprocessed.where( hsh ).order("updated_at desc").all
   carts = CartItem.unprocessed.in_cart.where(hsh).order("updated_at desc").all
   carts.reject!{|i| i.amount.nil? or i.amount == 0 }
   amnt = carts.first.try(:amount).to_i
   cart = carts.first
   mpq = search.mpq.to_i < 1 ? 1 : search.mpq
   rem = amnt % mpq == 0 ? amnt : amnt + mpq - (amnt % mpq)
   p_hsh = hsh.merge(:processed => false, :max_amount => search.max_qty, :min_amount => search.min_qty, :offer_params => search.raw_location, :amount => rem, :comment => cart.try(:comment), :application_area_id => cart.try(:application_area_id), :application_area_mandatory => search.application_area_mandatory, :reserve => cart.try(:reserve), :user_price => cart.try(:user_price), :pick => cart.try(:pick), :requirement => cart.try(:requirement)).merge(cart.nil? ? {:reserve => true, :pick => false} : {}).merge(amnt == rem ? {:pre_mpq => amnt} : {})
   item = self.setup_for(p_hsh).create(p_hsh)
   item.offer_params.merge!(search.raw_location)
   #item.amount = amnt
   item.save!
   fnd.each{|i| i.destroy }
   search.cart_id = item.id
   search.amount = item.amount
   
  end

  def setup_for(hash)
   self.class.setup_for(hash)
  end

  def self.setup_for(hash)
   return self if hash[:amount].to_i <= hash[:max_amount].to_i
   CartRequest
  end
end
