class CartWorld < CartItem
  def type_name
   I18n::t :cart_world
  end

  def self.prepare_codes(search)
   search.map do |search_hash|
    hsh = {:user_id => User.current.id, :product_link => search_hash["item_id"], :product_name => search_hash["item_name"], :product_rohs => search_hash["rohs"], :product_brend => search_hash["item_brend"], :location_link => search_hash["location_id"]}
    fnd = self.unprocessed.where( hsh ).order("updated_at desc").all
    if fnd.empty?
     fnd << self.create(hsh.merge(:draft => true, :processed => false, :avail_amount => search_hash["max_qty"], :min_amount => search_hash["min_qty"]))
    end #found/created
    item = fnd.shift
    unless fnd.empty?
     fnd.each{|i| i.destroy }
    end
    item.update_attributes(:avail_amount => search_hash["max_qty"], :min_amount => search_hash["min_qty"], :quantity => search_hash["qty_in_pack"])
    search_hash.merge(:cart_id => item.id)
   end
  end

  def self.prepare_offers(searches)
   searches.map do |search|
    hsh = {:user_id => User.current.id, :product_link => search.code, :product_name => search.name, :product_rohs => search.rohs, :product_brend => search.brend, :prognosis => search.prognoz, :quantity => search.qty_multiples, :avail_amount => search.max_qty}
    fnd = self.unprocessed.where( hsh ).order("updated_at desc").all
    if fnd.empty?
     fnd << self.create(hsh.merge(:draft => true, :processed => false, :min_amount => search.min_qty))
    end #found/created
    item = fnd.shift
    unless fnd.empty?
     fnd.each{|i| i.destroy }
    end
    item.update_attributes(:min_amount => search.min_qty)
    search.cart_id = item.id
   end
   searches
  end

  def offers(count) #ret hash product
   Axapta.search_dms_names( :item_id_search => product_link, :user_hash => User.current.current_account.axapta_hash)
  end

  def locate(offs, count) #rets loc or prgnz
  end

  def self.prepare_for(count, hsh, cart = nil)
   #prgnz = hsh["prognosis"]
   p "---prephsh", hsh["prognosis"]
   prgnz = hsh["prognosis"].select{|p| p["prognosis_id"] == cart.prognosis }.select{|p| p["vend_qty"] == cart.avail_amount }.select{|p| p["qty_multiples"] == cart.quantity }.first
   p "---prgnz", cart, hsh["prognosis"].select{|p| p["prognosis_id"] == cart.prognosis }.select{|p| p["vend_qty"] == cart.avail_amount }.select{|p| p["qty_multiples"] == cart.quantity }
   min = prgnz["price_qty"].map{|i| i.map{|l| l["price_qty"] }.flatten.compact["min_qty"] }.reject{|i| i.to_i <= 0 }.min
   count = hsh["min_qty"] if count < hsh["min_qty"].to_i
   p "---prep, off", prgnz
   selected = prgnz.first["price_qty"].detect{|v| count >= v["min_qty"] && count <= v["max_qty"] }
   {:type => self.name, :amount => count, :product_link => hsh["item_id"], :product_name => hsh["item_name"], :product_rohs => hsh["rohs"], :product_brend => hsh["item_brend"], :processed => false, :current_price => selected["price"], :quantity => hsh["qty_multiples"], :min_amount => hsh["min_qty"], :max_amount => hsh["locations"].first["vend_qty"], :avail_amount => hsh["locations"].first["vend_qty"], :draft => !(count > 0)}
  end

end
