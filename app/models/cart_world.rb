class CartWorld < CartItem
  @signature_fields = @base_signature_fields + [:prognosis, :max_amount, :quantity]

  def type_name
   I18n::t :cart_world
  end

  def allowed_actions
   %w()
  end


  def to_sales_lines
   init = super.merge(:max_qty => self.max_amount, :min_qty => self.min_amount, :prognosis_id => self.prognosis, :qty_multiples => self.quantity, :sales_price => self.current_price, :is_pick => true, :reserve_sale => self.reserve?)
   self.user_price.blank? ? init : init.merge(:sales_price => self.user_price)
  end


  def setup_price
   self.max_amount ||= 0
   self.min_amount ||= 0
   if self.amount and self.amount > 0
    self.amount = self.max_amount if self.amount > self.max_amount
    self.amount = self.min_amount if self.amount < self.min_amount
    if self.offer_params["price_qty"]
     self.current_price = self.offer_params["price_qty"].sort_by{|i| i["min_qty"].to_i }.reject{|i| i["min_qty"].to_i > self.amount }.last["price"].to_f
    else
     self.current_price = 0
    end
   else
    self.current_price = 0
   end
  end


  def self.prepare_code(search)
   hsh = {:user_id => User.current.id, :product_link => search.code, :product_name => search.name, :product_rohs => search.rohs, :product_brend => search.brend, :prognosis => search.prognoz, :quantity => search.qty_multiples, :max_amount => search.max_qty}
   fnd = self.unprocessed.where( hsh ).order("updated_at desc").all
   carts = CartItem.unprocessed.in_cart.where(hsh).order("updated_at desc").all
   carts.reject!{|i| i.amount.nil? or i.amount == 0 }
   cart = carts.first
   item = self.create(hsh.merge(:processed => false, :min_amount => search.min_qty, :offer_params => search.raw_prognosis, :comment => cart.try(:comment), :reserve => cart.try(:reserve), :user_price => cart.try(:user_price), :pick => cart.try(:pick)))
   item.offer_params.merge!(search.raw_prognosis)
   item.amount = carts.first.try(:amount)
   item.save!
   fnd.each{|i| i.destroy }
   search.cart_id = item.id
   search.amount = item.amount
  end

  def locate(offs, count) #rets loc or prgnz
  end

  def setup_for(hash)
   return self.class
  end

  def pick
   true
  end
  #def location_link
  # ::I18n.t :cart_world
  #end
end
