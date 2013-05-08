class Offer::Store < Offer::Base

 @signature_fields = @base_signature_fields + [:location_id]
 attr_accessor :location_id, :brend_name, :brend_url, :qtys, :prices, :counts, :need_more, :qty_in_pack, :segment_rus, :body_name, :analog_exists, :forecast_available, :min_qty, :max_qty, :raw_location, :vend_proposal_date, :alt_prices, :application_area_mandatory, :dlv_prognoses, :pick_only, :mpq, :reserve_control

  def self.search(hsh)
   return AxaptaResults.new([], {:type => AxaptaState::WARN, :error => "not found", :message => I18n.t("errors.search.empty")}) if hsh.blank? || (hsh[:external_code].blank? && (hsh[:query_string].blank? || hsh[:query_string].size < 3))
   data = Axapta.search_names({:show_forecast_availability => true, :show_analog_existence => true, :calc_price=>true, :calc_qty => true}.merge(hsh || {})).process{|d| fabricate(d) }

# :show_delivery_prognosis => true,
   #TODO: to offers
   #fabricate(data)
  end

  def self.fabricate(arr)
   rez = AxaptaResults.new.from_prepared([], arr)
   arr.each do |hsh|
    hsh.locations.each do |loc|
     rez << self.new do |n|
      n.name = hsh.item_name
      n.mpq = loc["mpq"]
      n.reserve_control = hsh.reserve_control
      n.brend = hsh.item_brend
      n.brend_name = hsh.item_brend_name
      n.brend_url = hsh.item_brend_url
      n.code = hsh.item_id
      n.rohs = hsh.rohs
      n.pick_only = hsh.pick_only
      n.location_id = loc["location_id"]
      #n.vend_qty = prgnz["vend_qty"]
      n.qty_in_pack = loc["qty_in_pack"]
      #n.name = hsh["item_name"]
      n.qtys = loc["price_qty"].sort_by{|p| p["min_qty"] }.inject([]){|rr, h| rr << OpenStruct.new(h) }
      n.prices = n.qtys.map{|p| p.price }
      n.alt_prices = n.qtys.map{|p| p.price_ref }
      n.counts = n.qtys.map{|p| p.min_qty }
      n.segment_rus = hsh.segment_rus
      n.body_name = hsh.package_name
      n.analog_exists = WebUtils.parse_bool(hsh.analog_exists)
      n.forecast_available = WebUtils.parse_bool(loc["forecast_available"])
      n.min_qty = hsh.min_qty
      n.max_qty = loc["vend_qty"]
      n.raw_location = loc
      n.dlv_prognoses = []
      loc.try(:[], "delivery_prognosis").each do |dlv|
       n.dlv_prognoses << {:date => dlv["delivery_date"], :qty => dlv["delivery_qty"]}
      end
      n.dlv_prognoses.delete_if{|x| x[:qty].to_i == 0 }
      #n.forecast_available &&= n.dlv_prognoses.size > 0
      n.application_area_mandatory = WebUtils.parse_bool(hsh.application_area_mandatory)
      #n.vend_proposal_date = nil
      CartStore.prepare_code(n)
     end
    end
   end
   rez
  end


end
