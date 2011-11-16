require 'spec_helper'

describe CartWorld do
 describe "#type_name" do
  it "should be dms" do
   CartWorld.new.type_name.should == 'ДМС'
  end
 end

 describe "::prepare_code" do
  it "should return hash" do
   CartWorld.prepare_codes([{}, {}]).should be_is_a(Array)
   CartWorld.prepare_codes([{}, {}]).each{|i| i.should be_is_a(Offer::World)}
  end
  it "should return valid hash"
  context "when new cart" do
   it "should create cart"
  end
  context "when cart exist" do
   it "should regenerate cart with reloaded data"
  end
 end
  pending "add some examples to (or delete) #{__FILE__}"
end
=begin
  def self.prepare_code(search_hash)
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
   #search_hash.merge()

  end

  def offers(count) #ret hash product
   Axapta.search_names(:calc_price => true, :calc_qty => true, :show_delivery_prognosis => true, :item_id_search => product_link, :invent_location_id => location_link, :user_hash => User.current.current_account.axapta_hash)
  end

  def self.prepare_for(count, hsh)
   return CartRequest.prepare_for(count, hsh) if hsh.blank? or count > (hsh["locations"].first["vend_qty"].to_i || 0)
   count = hsh["min_qty"] if count < hsh["min_qty"]
   p hsh, count
   selected = hsh["locations"].first["price_qty"].detect{|v| count >= v["min_qty"] && count <= v["max_qty"] }
   return CartRequest.prepare_for(count, hsh) unless selected
   {:type => self.name, :amount => count, :product_link => hsh["item_id"], :location_link => hsh["locations"].first["location_id"], :product_name => hsh["item_name"], :product_rohs => hsh["rohs"], :product_brend => hsh["item_brend"], :processed => false, :current_price => selected["price"], :quantity => hsh["qty_in_pack"], :min_amount => hsh["min_qty"], :max_amount => hsh["locations"].first["vend_qty"], :avail_amount => hsh["locations"].first["vend_qty"], :draft => !(count > 0)}
  end


=end

=begin
class: cmpECommerce_InventSearchDMS
input: 
  cust_account: 
    setter: setParCustAccount
    title: "код клиента"
  item_id_search: 
    setter: setItemIdSearch
    title: "код ном-ры"
    type: string
  query_string: 
    description: "Поддерживаются спеццсимволы * и ?"
    minlen: 3
    setter: setQuery
    title: "Поисковая строка"
    type: string
  search_brend: 
    setter: setSearchBrendAlias
    title: производитель
    type: string
  user_hash: 
    description: "Уникальный ключ пользователя, выдается при подключении"
    mandatory: true
    maxlen: 32
    minlen: 32
    setter: setcmpHashCode
    title: "Ключ пользователя"
    type: string
output: 
  items: 
    content: 
      item_brend: 
        getter: getinvcBrendAlias
        title: производитель
        type: string
      item_id: 
        getter: getItemId
        title: "код ном-ры"
        type: string
      item_name: 
        getter: getInventItemName
        title: наименование
        type: string
      prognosis: 
        content: 
          price_qty: 
            content: 
              max_qty: 
                getter: getMaxQty
                title: "макс. количество"
                type: integer
              min_qty: 
                getter: getMinQty
                title: "мин. количество"
                type: integer
              price: 
                getter: getPrice
                title: цена
                type: real
              price_ref: 
                getter: getPriceRef
                options: hide_if_empty
                title: "цена продажи"
              vend_proposal_date: 
                getter: getVendProposalDate
                title: "дата предложения"
                type: date
            iterator: nextPrice
            title: "цена - количество"
            type: array
          prognosis_days: 
            getter: getPrognosisToDays
            title: "прогноз в днях"
          prognosis_id: 
            getter: getPrognosisId
            title: прогноз
          qty_multiples: 
            getter: getQtyMultiples
            title: кратность
          vend_qty: 
            getter: getVendQty
            title: "общее количество у производителя"
            type: integer
        iterator: nextLocation
        title: "предложения по срока поставки"
        type: array
      rohs: 
        getter: getinvcInventItemPrefix
        title: ROHS
        type: string
    iterator: nextItem
    title: "результаты поиска"
    type: array
title: "поиск по ДМС"
=end
