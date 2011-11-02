class CartStore < CartItem
  def type_name
   ::I18N::t :cart_store
  end

  def self.prepare_code(current_user, search_hash)
   hsh = {:user_id => current_user.id, :product_link => search_hash["item_id"], :product_name => search_hash["item_name"], :product_rohs => search_hash["rohs"], :product_brend => search_hash["item_brend"], :location_link => search_hash["location_id"]}
   fnd = self.unprocessed.where( hsh ).order("updated_at desc").all
   if fnd.empty?
    fnd << self.create(hsh.merge(:draft => true, :processed => false, :avail_amount => search_hash["max_qty"], :min_amount => search_hash["min_qty"]))
   end #found/created
   item = fnd.shift
   unless fnd.empty?
    fnd.each{|i| i.destroy }
   end
   item.update_attributes(:avail_amount => search_hash["max_qty"], :min_amount => search_hash["min_qty"])
   search_hash.merge(:cart_id => item.id)
   #search_hash.merge()
   
  end
=begin
    i["locations"].each do |loc|
     a = {"item_name" => i["item_name"], "item_brend" => i["item_brend"], "item_brend_name" => i["item_brend_name"], "item_brend_url" => i["item_brend_url"], "qty_in_pack" => i["qty_in_pack"], "location_id" => loc["location_id"], "min_qty" => i["min_qty"], "max_qty" => loc["vend_qty"], "rohs" => i["rohs"], "item_id" => i["item_id"], "segment_rus" => i["segment_rus"], "body_name" => i["package_name"], "analog_exists" => WebUtils.parse_bool(i["analog_exists"]), "forecast_available" => WebUtils.parse_bool(loc["forecast_available"])}
     locs = loc["price_qty"].sort_by{|l| l["min_qty"] }[0, 4]
     a.merge!("price1" => locs[0]["price"]) if locs[0]
     a.merge!("price2" => locs[1]["price"], "count2" => locs[1]["min_qty"]) if locs[1]
     a.merge!("price3" => locs[2]["price"], "count3" => locs[2]["min_qty"]) if locs[2]
     a.merge!("price4" => locs[3]["price"], "count4" => locs[3]["min_qty"]) if locs[3]
     r << a
    end
    r
=end
end
