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



end
