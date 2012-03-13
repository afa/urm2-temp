class Axapta
 include ActiveModel
 include ActiveModel::Serialization
 def attributes
  @attributes ||= {}
 end
 attr_accessor :config
 attr_accessor :method

  def config
   @config ||= AxaptaRequest.describe_methods
  end

  def method(key)
   config["methods"][key.to_s]
  end

  def methods
   config["methods"].keys
  end

  def self.user_info(hash, axapta_uid = nil)
   args = {"user_hash" => hash}
   args.merge!("user_id" => axapta_uid) if axapta_uid
   AxaptaRequest.user_info(args)
  end

  def self.filter_account_attributes(args)
   args.inject({}){|r, a| r.merge(Account.axapta_renames[a[0]].nil? ? {a[0] => a[1]}: {Account.axapta_renames[a[0]] => a[1]}) }.delete_if{|k, v| not Account.axapta_attributes.include?(k.to_s) }
  end

  def self.renew_structure(hash) #REFACTOR: move to account
   accnt = Account.find_by_axapta_hash(hash)
   accnt.update_attributes self.filter_account_attributes(self.user_info(hash))
   accnt.parent.update_attributes self.filter_account_attributes(self.user_info(accnt.parent.axapta_hash)) if accnt.parent
   self.load_child_hashes(hash).each do |hsh|
    acc = Account.find_by_axapta_user_id(hsh["user_id"])
     acc.update_attributes self.filter_account_attributes(hsh) if acc
   end
  end

  def self.load_child_hashes(hash)
   AxaptaRequest.user_list("user_hash" => hash)["users"].map{|u| u["user_id"] }.map{|u| self.user_info(hash, u) }
  end

  def self.search_names(*args)
   ar = *args.dup
   ar["query_string"] += '*' if ar.has_key?("query_string") && ar["query_string"].last != '*'
   ar[:query_string] += '*' if ar.has_key?(:query_string) && ar[:query_string].last != '*'
   res = AxaptaRequest.search_item_name_h(ar).try(:[], "items") || []
  end

  def self.search_dms_names(*args)
   ar = *args.dup
   ar["query_string"] += '*' if ar.has_key?("query_string") && !ar["query_string"].blank? && ar["query_string"].last != '*'
   ar[:query_string] += '*' if ar.has_key?(:query_string) && !ar[:query_string].blank? && ar[:query_string].last != '*'
   res = AxaptaRequest.search_item_name_dms_h(ar).try(:[], "items") || []
  end

  def self.item_info(*args)
   ar = *args.dup
   res = AxaptaRequest.item_info(ar) || []
  end

  def self.search_analogs(*args)
   return [] unless args.first.has_key?("item_id_search") || args.first.has_key?(:item_id_search)
   srch = args.first["item_id_search"]
   srch = args.first[:item_id_search] unless srch
   res = AxaptaRequest.search_item_an_h(*args).try(:[], "items") || []
   res.select{|i| i.has_key?("item_id") && i["item_id"] != srch }
  end

  def self.retail_price(*args)
   return [] unless args.first.has_key?("item_id") || args.first.has_key?(:item_id)
   srch = args.first["item_id"]
   srch = args.first[:item_id] unless srch
   res = AxaptaRequest.retail_price(*args).try(:[], "prices") || []
   a = {}
   p ":::ax retprice ", res
   locs = res.sort_by{|l| l["min_qty"] }[0, 4]
   a.merge!("price1" => locs[0]["price"], "count1" => locs[0]["min_qty"]) if locs[0]
   a.merge!("price2" => locs[1]["price"], "count2" => locs[1]["min_qty"]) if locs[1]
   a.merge!("price3" => locs[2]["price"], "count3" => locs[2]["min_qty"]) if locs[2]
   a.merge!("price4" => locs[3]["price"], "count4" => locs[3]["min_qty"]) if locs[3]
   a
  end

  def self.make_order(hsh)
   hsh.merge!(:user_hash => User.current.current_account.axapta_hash, :main_invent_location => User.current.current_account.invent_location_id)
   AxaptaRequest.make_order(hsh)
  end

  def self.create_quotation(hsh)
   hsh.merge!(:user_hash => User.current.current_account.axapta_hash)
   AxaptaRequest.create_quotation(hsh)
  end

  def self.sales_info(*args)
   p "---sales_info_args", *args
   sales_info_paged(nil, *args).try(:items) || []
  end

  def self.sales_info_paged(page, *args)
   prm = *args.dup
   begin
    res = AxaptaRequest.sales_info({:user_hash => User.current.try(:current_account).try(:axapta_hash), :page_num => (page || prm[:page] || 1), :order_sales_date => "desc"}.merge(*args))
   rescue Exception => e
    return OpenStruct.new(:total => 0, :page => 0, :records => 0, :items => [], :error => e.to_s)
   end
   OpenStruct.new(:items => (res.try(:[], "sales") || []).map do |sale|
    OpenStruct.new sale
   end, :total => res.try(:[], "pages") || 1, :page => (page || prm[:page] || 1), :records => res.try(:[], "records") || 0)
  end

  def self.sales_lines(*args)
   sales_lines_paged(nil, *args).try(:items) || []
  end

  def self.sales_lines_paged(page, *args)
   prm = *args.dup
   res = AxaptaRequest.sales_lines({:user_hash => User.current.try(:current_account).try(:axapta_hash), :page_num => (page || prm[:page] || 1)}.merge(*args))
   OpenStruct.new(:items => (res.try(:[], "sales_lines") || []).map do |sale|
    OpenStruct.new sale
   end, :total => res.try(:[], "pages") || 1, :page => (page || prm[:page] || 1), :records => res.try(:[], "records") || 0)
  end

  def self.get_delivery_mode
   AxaptaRequest.get_dlv_mode(:user_hash => User.current.try(:current_account).try(:axapta_hash))
  end

  def self.create_invoice(order)
   AxaptaRequest.create_invoice(:user_hash => User.current.try(:current_account).try(:axapta_hash), :sales_id => order)
  end

  def self.quotation_info(hsh)
   quotation_info_paged(nil, hsh).try(:items) || []
  end

  def self.quotation_info_paged(page, hsh)
   res = AxaptaRequest.quotation_info({:page_num => (page || hsh[:page] || 1)}.merge(hsh).merge(:user_hash => User.current.try(:current_account).try(:axapta_hash)))
   OpenStruct.new(:items => (res.try(:[], "quotations") || []).map{|i| OpenStruct.new(i)}, :page => (page || hsh[:page] || 1), :total =>  res.try(:[], "pages") || 1, :records => res.try(:[], "records") || 0)
  end

  def self.quotation_lines(hsh)
   quotation_lines_paged(nil, hsh).try(:items) || []
  end

  def self.quotation_lines_paged(page, hsh)
   fix = {:item_name => hsh[:item_name]}
   unless fix[:item_name].blank?
    fix[:item_name] += '*' if fix[:item_name].last != '*'
    fix[:item_name] = "" if fix[:item_name].mb_chars.length < 4
   end
   res = AxaptaRequest.quotation_lines(hsh.merge(:page_num => (page || hsh[:page] || 1), :user_hash => User.current.try(:current_account).try(:axapta_hash)).merge(fix))
   OpenStruct.new(:items => (res.try(:[], "quotations_lines") || []).map{|i| OpenStruct.new(i)}, :page => (page || hsh[:page] || 1), :total =>  res.try(:[], "pages") || 1, :records => res.try(:[], "records") || 0)
  end

  def self.sales_handle_header(hsh)
   AxaptaRequest.sales_handle_header(hsh.merge(:user_hash => User.current.try(:current_account).try(:axapta_hash)))
  end

  def self.sales_handle_edit(hsh)
   AxaptaRequest.sales_handle_edit(hsh.merge(:user_hash => User.current.try(:current_account).try(:axapta_hash)))
  end
end
