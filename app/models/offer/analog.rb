class Offer::Analog < Offer::Store
 attr_accessor :analog_description, :analog_type
  def self.analogs(code)
   return [] if code.blank?
   data = Axapta.search_analogs(:calc_price=>true, :calc_qty => true, :item_id_search => code)
   fabricate(data).run do |its|
    its.each do |it|
     d = data.index{|i| it.item_id == i.item_id }
     if d
      it.analog_description = data[d].analog_description
      it.analog_type = data[d].analog_type
     end
    end
   end
  end

end
