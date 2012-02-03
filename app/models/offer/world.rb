require "ostruct"
class Offer::World < Offer::Base

  @signature_fields = @base_signature_fields + [:prognoz, :vend_qty, :qty_multiples]

  attr_accessor :prognoz, :vend_qty, :qty_multiples, :vend_proposal_date, :qtys, :prices, :counts, :need_more, :raw_prognosis, :alt_prices

  def self.ask_axapta_by_id(product_id)
   return [] if product_id.blank?
   hshs = Axapta.search_name(:user_hash => User.current.current_account.try(:axapta_hash), :item_id_search => product_id)
   #:query_string, :search_brend
   rez = []
   hshs.each do |hsh|
    hsh["prognosis"].each do |loc|
     a = {"item_name" => i["item_name"], "item_brend" => i["item_brend"], "qty_multiples" => loc["qty_multiples"], "max_qty" => loc["vend_qty"], "rohs" => i["rohs"], "prognosis_id" => loc["prognosis_id"]}#, "min_qty" => i["min_qty"], "location_id" => loc["location_id"]
     locs = loc["price_qty"].sort_by{|l| l["min_qty"] }[0, 4]
     a.merge!("price1" => locs[0]["price"], "min_qty" => locs[0]["min_qty"], "vend_proposal_date" => locs[0]["vend_proposal_date"]) if locs[0]
     a.merge!("price2" => locs[1]["price"], "count2" => locs[1]["min_qty"]) if locs[1]
     a.merge!("price3" => locs[2]["price"], "count3" => locs[2]["min_qty"]) if locs[2]
     a.merge!("price4" => locs[3]["price"], "count4" => locs[3]["min_qty"]) if locs[3]
     a.merge!("need_more" => true) if loc["price_qty"].size > 4
     r << a
    end
    r
   end
  end

  def location_id
  end

  def max_qty
   self.vend_qty
  end

  def min_qty
   counts[0] || 0
  end

  def self.by_code(product_code)
   return [] if product_code.blank?
   hash = User.current.current_account.try(:axapta_hash)
   items = Axapta.search_dms_names(:user_hash => hash, :item_id_search => product_code)
   #items = conv_dms_items(Axapta.search_dms_names(:user_hash => hash, :item_id_search => product_code))
   fabricate(items)
  end

  def self.fabricate(arr)
   rez = []
   arr.each do |hsh|
    hsh["prognosis"].each do |prgnz|
     rez << Offer::World.new do |n|
      n.name = hsh["item_name"]
      n.brend = hsh["item_brend"]
      n.code = hsh["item_id"]
      n.rohs = hsh["rohs"]
      n.prognoz = prgnz["prognosis_id"]
      n.vend_qty = prgnz["vend_qty"]
      n.qty_multiples = prgnz["qty_multiples"]
      #n.name = hsh["item_name"]
      n.qtys = prgnz["price_qty"].sort_by{|p| p["min_qty"] }.inject([]){|rr, h| rr << OpenStruct.new(h) }
      n.prices = n.qtys.map{|p| p.price }
      n.alt_prices = n.qtys.map{|p| p.price_ref }
      n.counts = n.qtys.map{|p| p.min_qty }
      n.raw_prognosis = prgnz
      CartWorld.prepare_code(n)
     end
    end
   end
   rez
  end

  def self.by_query(query, brend = nil)
   return [] if query.blank?
   hash = User.current.current_account.try(:axapta_hash)
   items = Axapta.search_dms_names(:user_hash => hash, :query_string => query, :search_brend => brend)
   #items = conv_dms_items(Axapta.search_dms_names(:user_hash => hash, :query_string => query, :search_brend => brend))
   fabricate(items)
  end

=begin
  def self.conv_dms_items(items)
   items.inject([]) do |r, i|
    i["prognosis"].each do |loc|
     a = {"item_name" => i["item_name"], "item_brend" => i["item_brend"], "qty_multiples" => loc["qty_multiples"], "max_qty" => loc["vend_qty"], "rohs" => i["rohs"], "prognosis_id" => loc["prognosis_id"]}#, "min_qty" => i["min_qty"], "location_id" => loc["location_id"]
     locs = loc["price_qty"].sort_by{|l| l["min_qty"] }[0, 4]
     a.merge!("price1" => locs[0]["price"], "min_qty" => locs[0]["min_qty"], "vend_proposal_date" => locs[0]["vend_proposal_date"]) if locs[0]
     a.merge!("price2" => locs[1]["price"], "count2" => locs[1]["min_qty"]) if locs[1]
     a.merge!("price3" => locs[2]["price"], "count3" => locs[2]["min_qty"]) if locs[2]
     a.merge!("price4" => locs[3]["price"], "count4" => locs[3]["min_qty"]) if locs[3]
     a.merge!("need_more" => true) if loc["price_qty"].size > 4
     r << a
    end
    r
   end
  end
=end

=begin
  def self.mass_load(query_string)
   hash = User.current.current_account.try(:axapta_hash)
   begin
    items = conv_dms_items(Axapta.search_dms_names(:user_hash => hash, :query_string => query_string))
    CartWorld.prepare_codes(@items)
   rescue Exception
    items = []
   end
   hsh = items.inject({}) do |r, item|
    i = WebUtils.escape_name("#{item["item_name"]}_#{item["item_brend"]}_#{item["rohs"]}")
    unless r.has_key?(i)
     r[i] = []
    end
    r[i] << item
    r
   end
   
  end
=end

=begin
   @after = params[:after]
   @seek = params[:name]
   @code = params[:code]
   @brend = params[:brend]
   @hash = current_user.current_account.try(:axapta_hash)
   @items = conv_dms_items(Axapta.search_dms_names(:user_hash => @hash, :item_id_search => @code, :query_string => @seek, :search_brend => @brend))
   CartWorld.prepare_codes(@items)
   respond_with do |format|
    format.json do
     render :json => {:dms => render_to_string( :partial => "main/dms_block.html", :locals => {:items => @items, :after => @after} ), :gap => render_to_string( :partial => "main/gap_line.html", :locals => {:after => @after}), :empty => render_to_string(:partial => "main/dms_empty.html", :locals => {:after => @after})}
    end
    format.js { render :layout => false }
    format.html do
     redirect_to root_path
    end
   end
  end

  def conv_dms_items(items)
   items.inject([]) do |r, i|
    i["prognosis"].each do |loc|
     a = {"item_name" => i["item_name"], "item_brend" => i["item_brend"], "qty_multiples" => loc["qty_multiples"], "max_qty" => loc["vend_qty"], "rohs" => i["rohs"], "prognosis_id" => loc["prognosis_id"]}#, "min_qty" => i["min_qty"], "location_id" => loc["location_id"]
     locs = loc["price_qty"].sort_by{|l| l["min_qty"] }[0, 4]
     a.merge!("price1" => locs[0]["price"], "min_qty" => locs[0]["min_qty"], "vend_proposal_date" => locs[0]["vend_proposal_date"]) if locs[0]
     a.merge!("price2" => locs[1]["price"], "count2" => locs[1]["min_qty"]) if locs[1]
     a.merge!("price3" => locs[2]["price"], "count3" => locs[2]["min_qty"]) if locs[2]
     a.merge!("price4" => locs[3]["price"], "count4" => locs[3]["min_qty"]) if locs[3]
     a.merge!("need_more" => true) if loc["price_qty"].size > 4
     r << a
    end
    r
   end

  end
=end
=begin
   @hash = current_user.current_account.try(:axapta_hash)
   begin
    @items = conv_dms_items(Axapta.search_dms_names(:user_hash => @hash, :query_string => params[:query_string]))
    CartWorld.prepare_codes(@items)
   rescue Exception
    @items = []
   end
   hsh = @items.inject({}) do |r, item|
    i = WebUtils.escape_name("#{item["item_name"]}_#{item["item_brend"]}_#{item["rohs"]}")
    unless r.has_key?(i)
     r[i] = []
    end
    r[i] << item
    r
   end
=end


end
