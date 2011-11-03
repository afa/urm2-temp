class CartStore < CartItem
  def type_name
   ::I18n::t :cart_store
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

  def offers(count) #ret hash product
   Axapta.search_names(:calc_price => true, :calc_qty => true, :show_delivery_prognosis => true, :item_id_search => product_link, :invent_location_id => location_link, :user_hash => User.current.current_account.axapta_hash)
  end

  def self.prepare_for(count, hsh)
   count = hsh["min_qty"] if count < hsh["min_qty"]
   return CartRequest.prepare_for(count, hsh) if count > hsh["locations"].first["vend_qty"]
   p hsh, count
   selected = hsh["locations"].first["price_qty"].detect{|v| count >= v["min_qty"] && count <= v["max_qty"] }
   return CartRequest.prepare_for(count, hsh) unless selected
   {:type => self.name, :amount => count, :product_link => hsh["item_id"], :location_link => hsh["locations"].first["location_id"], :product_name => hsh["item_name"], :product_rohs => hsh["rohs"], :product_brend => hsh["item_brend"], :processed => false, :current_price => selected["price"], :quantity => hsh["qty_in_pack"], :min_amount => hsh["min_qty"], :max_amount => hsh["locations"].first["vend_qty"], :avail_amount => hsh["locations"].first["vend_qty"], :draft => !(count > 0)}
  end
=begin
"rohs"=>"", "analog_exists"=>false, "item_brend_name"=>"CONTINENTAL DEVICE INDIA LTD.", "min_qty"=>98, "item_name"=>"2N2222A", "segment_rus"=>"п═п╣п╪п╬п╫я┌", "locations"=>[{"delivery_prognosis"=>[], "price_qty"=>[{"price"=>0.3469, "min_qty"=>98, "price_ref"=>0, "max_qty"=>952}], "forecast_available"=>false, "vend_qty"=>952, "location_id"=>"CENTRE"}], "item_brend_url"=>"", "item_id"=>"270670", "item_brend"=>"CDIL", "package_name"=>"TO-18", "qty_in_pack"=>1000
-end


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
