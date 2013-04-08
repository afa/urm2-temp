class CartRequest < CartItem
 @signature_fields = @base_signature_fields + [:location_link]

 after_initialize :init_bools

  def allow
   true
  end

  def allowed_actions
   %w()
  end

  def type_name
   ::I18n::t :cart_request
  end

  def to_sales_lines
   super.merge(:invent_location => location_link)
  end


  def offers(count) #ret hash product
   Axapta.search_names(:calc_price => true, :calc_qty => true, :show_delivery_prognosis => true, :item_id_search => product_link, :invent_location_id => location_link)
  end

  def self.prepare_code(search)
   hsh = {:user_id => User.current.id, :product_link => search.code, :product_name => search.name, :product_rohs => search.rohs, :product_brend => search.brend, :location_link => search.location_id}
   fnd = CartItem.unprocessed.where( hsh ).order("updated_at desc").all
   carts = CartItem.unprocessed.in_cart.where(hsh).order("updated_at desc").all
   carts.reject!{|i| i.amount.nil? or i.amount == 0 }
   cart = carts.first
   amnt = carts.first.try(:amount)
   p_hsh = hsh.merge(:processed => false, :max_amount => search.max_qty, :min_amount => search.min_qty, :offer_params => search.raw_location, :amount => amnt, :comment => cart.try(:comment), :reserve => cart.try(:reserve), :user_price => cart.try(:user_price), :pick => cart.try(:pick))
   item = self.setup_for(p_hsh).create(p_hsh)
   item.offer_params.merge!(search.raw_location)
   item.amount = amnt
   item.save!
   fnd.each{|i| i.destroy }
   search.cart_id = item.id
   search.amount = item.amount

  end


  def self.prepare_for(count, hsh)
   return CartStore.prepare_for(count, hsh) if !hsh.blank? and count <= hsh["locations"].first["vend_qty"]
   p hsh, count
   {:type => self.name, :amount => count, :product_link => hsh["item_id"], :location_link => hsh["locations"].first["location_id"], :product_name => hsh["item_name"], :product_rohs => hsh["rohs"], :product_brend => hsh["item_brend"], :processed => false, :current_price => 0, :quantity => hsh["qty_in_pack"], :min_amount => hsh["min_qty"], :max_amount => hsh["locations"].first["vend_qty"], :draft => !(count > 0)}
  end

  def setup_for(hash)
   self.class.setup_for(hash)
  end

  def self.setup_for(hash)
   return self if hash[:amount].nil? or hash[:max_amount].nil? or hash[:max_amount].to_i == 0
   return self if hash[:amount] > hash[:max_amount]
   CartStore
  end

 protected
  def init_bools
   self.pick = false
   self.reserve = false
  end
end
