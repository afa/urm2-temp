require "array_utils"
class AxaptaError < Exception; end
class Axapta
 include ActiveModel
 include ActiveModel::Serialization

  def self.parse_exc(e)
   @last_parsed_error = ActiveSupport::JSON.decode(e.message.scan(/JSON-RPC error ::\((.+)\)::.+\{.+\}/)[0][0])
   {"_error" => @last_parsed_error}
  end

  def self.get_last_exc
   {"_error" => @last_parsed_error}
  end

  def self.clean_exc
   @last_parsed_error = nil
  end

 def attributes
  @attributes ||= {}
 end
 attr_accessor :config
 attr_accessor :method

  def config
   begin
    @config ||= AxaptaRequest.describe_methods
   rescue Exception => e
    parse_exc(e)
    {}
   end
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

  def self.renew_structure(hash) #REFACTOR: move to account
   accnt = Account.find_by_axapta_hash(hash)
   accnt.update_attributes Account.filter_account_attributes(self.user_info(hash))
   accnt.parent.update_attributes Account.filter_account_attributes(self.user_info(accnt.parent.axapta_hash)) if accnt.parent
   self.load_child_hashes(hash).each do |hsh|
    acc = Account.find_by_axapta_user_id(hsh["user_id"])
     acc.update_attributes Account.filter_account_attributes(hsh) if acc
   end
  end

  def self.load_child_hashes(hash)
   AxaptaRequest.user_list("user_hash" => hash)["users"].map{|u| u["user_id"] }.map{|u| self.user_info(hash, u) }
  end

  def self.search_names(*args)
   ar = args.as_hash
   ar["query_string"] += '*' if ar.has_key?("query_string") && ar["query_string"].last != '*'
   ar[:query_string] += '*' if ar.has_key?(:query_string) && ar[:query_string].last != '*'
   begin
    res = AxaptaRequest.search_item_name_h(ar).try(:[], "items") || []
   rescue Exception => e
    parse_exc(e)
    []
   end
  end

  def self.search_dms_names(*args)
   ar = args.as_hash
   ar["query_string"] += '*' if ar.has_key?("query_string") && !ar["query_string"].blank? && ar["query_string"].last != '*'
   ar[:query_string] += '*' if ar.has_key?(:query_string) && !ar[:query_string].blank? && ar[:query_string].last != '*'
   begin
    res = AxaptaRequest.search_item_name_dms_h(ar).try(:[], "items") || []
   rescue Exception => e
    parse_exc(e)
    []
   end
  end

  def self.item_info(*args)
   ar = args.as_hash
   begin
    AxaptaRequest.item_info(ar) || []
   rescue Exception => e
    parse_exc(e)
    []
   end
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
   hsh.merge!(:user_hash => axapta_hash, :main_invent_location => User.current.current_account.invent_location_id)
   AxaptaRequest.make_order(hsh)
  end

  def self.create_quotation(hsh)
   hsh.merge!(:user_hash => axapta_hash)
   AxaptaRequest.create_quotation(hsh)
  end

  def self.sales_info(*args)
   sales_info_paged(nil, *args).try(:items) || []
  end

  def self.sales_info_paged(page, *args)
   prm = args.dup.as_hash
   begin
    res = AxaptaRequest.sales_info({:user_hash => axapta_hash, :page_num => (page || prm[:page] || 1), :order_sales_id => "desc"}.merge(prm))
    #res = AxaptaRequest.sales_info({:user_hash => axapta_hash, :page_num => (page || prm[:page] || 1), :order_sales_id => "desc"}.merge(*args))
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
   prm = args.dup.as_hash
   res = AxaptaRequest.sales_lines({:user_hash => axapta_hash, :page_num => (page || prm[:page] || 1)}.merge(prm))
   #res = AxaptaRequest.sales_lines({:user_hash => axapta_hash, :page_num => (page || prm[:page] || 1)}.merge(*args))
   OpenStruct.new(:items => (res.try(:[], "sales_lines") || []).map do |sale|
    OpenStruct.new sale
   end, :total => res.try(:[], "pages") || 1, :page => (page || prm[:page] || 1), :records => res.try(:[], "records") || 0)
  end

  def self.get_delivery_mode
   AxaptaRequest.get_dlv_mode(:user_hash => axapta_hash)
  end

  def self.create_invoice(order, send = false)
   begin
    AxaptaRequest.create_invoice(:user_hash => axapta_hash, :sales_id => order, :send_by_email => send)
   rescue Exception => e
    parse_exc(e)
    raise AxaptaError
   end
  end

  def self.invoice_paym(order, send = false)
   begin
    AxaptaRequest.invoice_paym(:user_hash => axapta_hash, :sales_id => order, :send_by_email => send)
   rescue Exception => e
    parse_exc(e)
    raise AxaptaError
   end
  end

  def self.quotation_info(hsh)
   quotation_info_paged(nil, hsh).try(:items) || []
  end

  def self.quotation_info_paged(page, hsh)
   res = AxaptaRequest.quotation_info({:page_num => (page || hsh[:page] || 1)}.merge(hsh).merge(:user_hash => axapta_hash))
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
   res = AxaptaRequest.quotation_lines(hsh.merge(:page_num => (page || hsh[:page] || 1), :user_hash => axapta_hash).merge(fix))
   OpenStruct.new(:items => (res.try(:[], "quotations_lines") || []).map{|i| OpenStruct.new(i)}, :page => (page || hsh[:page] || 1), :total =>  res.try(:[], "pages") || 1, :records => res.try(:[], "records") || 0)
  end

  def self.sales_handle_header(hsh)
   begin
    AxaptaRequest.sales_handle_header(hsh.merge(:user_hash => axapta_hash))
   rescue Exception => e
    parse_exc(e)
    raise AxaptaError
   end
  end

  def self.sales_handle_edit(hsh)
   begin
    AxaptaRequest.sales_handle_edit(hsh.merge(:user_hash => axapta_hash))
   rescue Exception => e
    parse_exc(e)
    raise AxaptaError
   end
  end

  def self.sales_close_reason_list
   begin
    AxaptaRequest.sales_close_reason_list(:user_hash => axapta_hash)["reason_list"].map{|x| [x["close_reason_description"], x["close_reason_id"]] } #return [[desc, id]]
   rescue Exception => e
    parse_exc(e)
    []
   end
  end

  def self.application_area_list
   begin
    AxaptaRequest.application_area_list(:user_hash => axapta_hash)["area_list"].map{|x| OpenStruct.new(x)}
   rescue Exception => e
    parse_exc(e)
    []
   end
  end
 private
  def self.axapta_hash
   unless User.current
    @last_parsed_error = {"message" => "Non-selected user"}
    raise AxaptaError
   end
   unless User.current.current_account
    @last_parsed_error = {"message" => "Invalid current account for current user"}
    raise AxaptaError
   end
   
   User.current.current_account.axapta_hash
  end
end
