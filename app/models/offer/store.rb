class Offer::Store < Offer::Base

 SIGNATURE_FIELDS << :location_id
 attr_accessor :location_id, :brend_name, :brend_url, :qtys, :prices, :counts, :need_more

  def self.search(hsh)
   return [] if hsh.empty? || hsh[:query_string].blank? || hsh[:query_string].size < 3
   begin
    data = Axapta.search_names({:show_forecast_availability => true, :show_analog_existence => true, :calc_price=>true, :calc_qty => true}.merge(hsh || {}).merge(:user_hash => User.current.current_account.try(:axapta_hash)))
   rescue Exception => e
    p "---exc in search #{Time.now}", e
    logger.info e.to_s
    return []
   end
   #TODO: to offers
   fabricate(data)
  end

  def self.fabricate(arr)
     r << CartStore.prepare_code(a)

   rez = []
   arr.each do |hsh|
    hsh["locations"].each do |loc|
     rez << Offer::Store.new do |n|
      n.name = hsh["item_name"]
      n.brend = hsh["item_brend"]
      n.brend_name = hsh["item_brend_name"]
      n.brend_url = hsh["item_brend_url"]
      n.code = hsh["item_id"]
      n.rohs = hsh["rohs"]
      n.location_id = loc["location_id"]
      #n.vend_qty = prgnz["vend_qty"]
      n.qty_in_pack = loc["qty_in_pack"]
      #n.name = hsh["item_name"]
      n.qtys = loc["price_qty"].sort_by{|p| p["min_qty"] }.inject([]){|rr, h| rr << OpenStruct.new(h) }
      n.prices = n.qtys.map{|p| p.price }
      n.counts = n.qtys.map{|p| p.min_qty }
      n.segment_rus = hsh["segment_rus"]
      n.body_name = hsh["package_name"]
      n.analog_exists = WebUtils.parse_bool(hsh["analog_exists"])
      n.forecast_available = WebUtils.parse_bool(loc["forecast_available"])
      n.min_qty = hsh["min_qty"]
      n.max_qty = loc["vend_qty"]
     end
    end
   end
   rez
  end

end
