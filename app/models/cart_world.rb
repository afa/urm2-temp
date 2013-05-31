class CartWorld < CartItem
  include Cart::WorldStore
  @signature_fields = @base_signature_fields + [:prognosis, :max_amount, :quantity]

  def type_name
   I18n::t :cart_world
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


  def locate(offs, count) #rets loc or prgnz
  end

  def self.setup_for(hash)
   return self if hash[:amount].to_i <= hash[:max_amount].to_i
   CartWorldAskMan
  end

  def pick
   true
  end
  #def location_link
  # ::I18n.t :cart_world
  #end
end
