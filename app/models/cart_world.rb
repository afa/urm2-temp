class CartWorld < CartItem
  def type_name
   I18n::t :cart_world
  end

  def to_sales_lines
   super.merge(:max_qty => self.max_amount, :min_qty => self.min_amount, :prognosis_id => self.prognosis, :qty_multiples => self.quantity, :sales_price => self.current_price)
  end

  def setup_price
   self.max_amount ||= 0
   self.min_amount ||= 0
   if self.amount and self.amount > 0
    self.amount = self.max_amount if self.amount > self.max_amount
    self.amount = self.min_amount if self.amount < self.min_amount
    self.current_price = self.offer_params["price_qty"].sort_by{|i| i["min_qty"].to_i }.reject{|i| i["min_qty"].to_i > amount }.last["price"].to_f
   else
    self.current_price = 0
   end
  end

=begin
  def self.prepare_codes(search)
   search.map do |search_hash|
    hsh = {:user_id => User.current.id, :product_link => search_hash["item_id"], :product_name => search_hash["item_name"], :product_rohs => search_hash["rohs"], :product_brend => search_hash["item_brend"], :location_link => search_hash["location_id"]}
    fnd = self.unprocessed.where( hsh ).order("updated_at desc").all
    if fnd.empty?
     fnd << self.create(hsh.merge(:draft => true, :processed => false, :max_amount => search_hash["max_qty"], :min_amount => search_hash["min_qty"]))
    end #found/created
    item = fnd.shift
    unless fnd.empty?
     fnd.each{|i| i.destroy }
    end
    item.update_attributes(:max_amount => search_hash["max_qty"], :min_amount => search_hash["min_qty"], :quantity => search_hash["qty_in_pack"])
    search_hash.merge(:cart_id => item.id)
   end
  end
=end

  def self.prepare_code(search)
   hsh = {:user_id => User.current.id, :product_link => search.code, :product_name => search.name, :product_rohs => search.rohs, :product_brend => search.brend, :prognosis => search.prognoz, :quantity => search.qty_multiples, :max_amount => search.max_qty}
   fnd = self.unprocessed.where( hsh ).order("updated_at desc").all
   #if fnd.empty?
   item = self.create(hsh.merge(:draft => true, :processed => false, :min_amount => search.min_qty, :offer_params => search.raw_prognosis))
   p "---prepcode", search, search.raw_prognosis, item.offer_params 
   #else
    
   #end #found/created
   fnd.each{|i| i.destroy }
   search.cart_id = item.id
  end

  #def offers(count) #ret hash product
  # Axapta.search_dms_names( :item_id_search => product_link, :user_hash => User.current.current_account.axapta_hash)
  #end

  def locate(offs, count) #rets loc or prgnz
  end

  def setup_for(hash)
   return self.class
  end
=begin
  def self.prepare_for(count, hsh, cart = nil)
   #prgnz = hsh["prognosis"]
   p "---prephsh", hsh["prognosis"]
   prgnz = hsh["prognosis"].select{|p| p["prognosis_id"] == cart.prognosis }.select{|p| p["vend_qty"] == cart.max_amount }.select{|p| p["qty_multiples"] == cart.quantity }.first
   p "---prgnz", cart, hsh["prognosis"].select{|p| p["prognosis_id"] == cart.prognosis }.select{|p| p["vend_qty"] == cart.max_amount }.select{|p| p["qty_multiples"] == cart.quantity }
   min = prgnz["price_qty"].map{|i| i.map{|l| l["price_qty"] }.flatten.compact["min_qty"] }.reject{|i| i.to_i <= 0 }.min
   count = hsh["min_qty"] if count < hsh["min_qty"].to_i
   p "---prep, off", prgnz
   selected = prgnz.first["price_qty"].detect{|v| count >= v["min_qty"] && count <= v["max_qty"] }
   {:type => self.name, :amount => count, :product_link => hsh["item_id"], :product_name => hsh["item_name"], :product_rohs => hsh["rohs"], :product_brend => hsh["item_brend"], :processed => false, :current_price => selected["price"], :quantity => hsh["qty_multiples"], :min_amount => hsh["min_qty"], :max_amount => hsh["locations"].first["vend_qty"], :max_amount => hsh["locations"].first["vend_qty"], :draft => !(count > 0)}
  end
=end

end
