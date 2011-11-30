class CartStore < CartItem
  def type_name
   ::I18n::t :cart_store
  end

  def allowed_actions
   %w(reserve pick)
  end

  def to_sales_lines
   init = super.merge(:invent_location => location_link, :is_pick => self.pick?, :reserve_sale => self.reserve?)
   self.user_price.blank? ? init : init.merge(:sales_price => self.user_price)
  end
=begin
    #  invc_brend_alias:
    #    setter: setDMSinvcBrendAlias
    #  invent_location:
    #    setter: setInventLocationId
    #    title: склад
    #    type: string
      is_pick:
        setter: setIsPick
        title: "бронировать строку"
        type: boolean
   #   item_id:
   #     setter: setItemId
   #     title: "код ном-ры"
   #     type: string
   #   item_name:
   #     setter: setInvcInventItemName
   #   line_customer_delivery_type_id:
   #     setter: setLineCustDlvMode
   #   line_type:
   #     setter: setEPXLineType
   #     title: "тип строки (order / dms)"
   #     type: string
      max_qty:
        setter: setDMSPurchAutoMaxQty
      min_qty:
        setter: setDMSPurchAutoMinQty
      prognosis_id:
        setter: setDMSPrognosisId
   #   qty:
   #     setter: setQty
   #     title: количество
   #     type: real
      qty_multiples:
        setter: setDMSqtyMultiples
      reserve_sale:
        setter: setReserveSale
        title: резервировать
        type: boolean
   #   sales_price:
   #     description: "необязательное. заполняется для ДМС или для стока, если это разрешено правами."
   #     setter: setSalesPrice
   #     title: цена
=end


  def self.prepare_code(search) #on find, chg search hash to offers array
   #FIXME: fix for generation
   hsh = {:user_id => User.current.id, :product_link => search.code, :product_name => search.name, :product_rohs => search.rohs, :product_brend => search.brend, :location_link => search.location_id}
   fnd = CartItem.unprocessed.where( hsh ).order("updated_at desc").all
   carts = CartItem.unprocessed.in_cart.where(hsh).where("amount > 0").order("updated_at desc").all
   #if fnd.empty?
   item = self.create(hsh.merge(:processed => false, :max_amount => search.max_qty, :min_amount => search.min_qty, :offer_params => search.raw_location))
   item.offer_params.merge!(search.raw_location)
   carts.reject!{|i| i.amount.nil? or i.amount == 0 }
   item.amount = carts.first.try(:amount)
   item.save!
   #else
    #item = self.create(hsh.merge(:draft => true, :processed => false, :max_amount => search.max_qty, :min_amount => search.min_qty, :quantity => search.qty_in_pack, :offer_params => search.raw_location))
   #end #found/created
   fnd.each{|i| i.destroy }
   #item.update_attributes(:max_amount => search_hash["max_qty"], :min_amount => search_hash["min_qty"], :quantity => search_hash["qty_in_pack"])
   search.cart_id = item.id
   search.amount = item.amount
   
  end

  #def offers(count) #ret hash product
  # Axapta.search_names(:calc_price => true, :calc_qty => true, :show_delivery_prognosis => true, :item_id_search => product_link, :invent_location_id => location_link, :user_hash => User.current.current_account.axapta_hash)
  #end

=begin
  def self.prepare_for(count, hsh)
   return CartRequest.prepare_for(count, hsh) if hsh.blank? or count > (hsh["locations"].first["vend_qty"].to_i || 0)
   count = hsh["min_qty"] if count < hsh["min_qty"]
   p hsh, count
   selected = hsh["locations"].first["price_qty"].detect{|v| count >= v["min_qty"] && count <= v["max_qty"] }
   return CartRequest.prepare_for(count, hsh) unless selected
   {:type => self.name, :amount => count, :product_link => hsh["item_id"], :location_link => hsh["locations"].first["location_id"], :product_name => hsh["item_name"], :product_rohs => hsh["rohs"], :product_brend => hsh["item_brend"], :processed => false, :current_price => selected["price"], :quantity => hsh["qty_in_pack"], :min_amount => hsh["min_qty"], :max_amount => hsh["locations"].first["vend_qty"], :draft => !(count > 0)}
  end
=end

  def setup_for(hash)
   return self.class if hash[:amount].to_i <= hash[:max_amount].to_i
   CartRequest
  end

end
