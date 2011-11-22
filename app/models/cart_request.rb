class CartRequest < CartItem

  def allow
   true
  end

  def type_name
   ::I18n::t :cart_request
  end

  def to_sales_lines
   super.merge(:invent_location => location_link)
  end
=begin
    #  invc_brend_alias:
    #    setter: setDMSinvcBrendAlias
      invent_location:
        setter: setInventLocationId
        title: склад
        type: string
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
      line_type:
        setter: setEPXLineType
        title: "тип строки (order / dms)"
        type: string
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
      sales_price:
        description: "необязательное. заполняется для ДМС или для стока, если это разрешено правами."
        setter: setSalesPrice
        title: цена
=end


  def offers(count) #ret hash product
   Axapta.search_names(:calc_price => true, :calc_qty => true, :show_delivery_prognosis => true, :item_id_search => product_link, :invent_location_id => location_link, :user_hash => User.current.current_account.axapta_hash)
  end

  def self.prepare_for(count, hsh)
   return CartStore.prepare_for(count, hsh) if !hsh.blank? and count <= hsh["locations"].first["vend_qty"]
   p hsh, count
   {:type => self.name, :amount => count, :product_link => hsh["item_id"], :location_link => hsh["locations"].first["location_id"], :product_name => hsh["item_name"], :product_rohs => hsh["rohs"], :product_brend => hsh["item_brend"], :processed => false, :current_price => 0, :quantity => hsh["qty_in_pack"], :min_amount => hsh["min_qty"], :max_amount => hsh["locations"].first["vend_qty"], :draft => !(count > 0)}
  end

  def setup_for(hash)
   return self.class if hash[:amount] > hash[:vend_qty]
   CartStore
  end
end
