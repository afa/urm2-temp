require "array_utils"
class AxaptaError < Exception; end
class AxaptaState
 OK = 0
 WARN = 1
 FATAL = 2
 INVALID = 3
 NONVALID = 4
end
class AxaptaResult < OpenStruct
  attr_accessor :type, :error, :message
  def initialize(attrs = {})
   self.type = attrs.delete(:type) || attrs.delete("type")
   self.error = attrs.delete(:error) || attrs.delete("error")
   self.message = attrs.delete(:message) || attrs.delete("message")
   super
  end

  def from_prepared(hsh, parm)
   dmp = hsh.is_a?(AxaptaResult) ? hsh.marshal_dump : hsh
   #.marshal_dump.inject(OpenStruct.new){|r, (k, v)| r.send(k.to_s + '=', OpenStruct.new(v)) ; r }
   dmp.inject(self){|r, (k, v)| r.send(k.to_s + '=', OpenStruct.new(v)); r }
   self.type = parm.delete(:type) || parm.delete("type")
   self.error = parm.delete(:error) || parm.delete("error")
   self.message = parm.delete(:message) || parm.delete("message")
   self
  end

  def params
   {:type => type, :error => error, :message => message}
  end
end

class AxaptaResults < Array
  attr_accessor :type, :error, :message
  def initialize(arr = [], opts = {})
   self.type = opts.delete(:type) || opts.delete("type")
   self.error = opts.delete(:error) || opts.delete("error")
   self.message = opts.delete(:message) || opts.delete("message")
   super(arr.map{|i| OpenStruct.new(i.as_hash) })
  end

  def from_prepared(arr, parm)
   self.clear
   self.concat(arr)
   self.type = parm.delete(:type) || parm.delete("type")
   self.error = parm.delete(:error) || parm.delete("error")
   self.message = parm.delete(:message) || parm.delete("message")
   self
  end

  def params
   {:type => type, :error => error, :message => message}
  end
end

class AxaptaPages < AxaptaResults
  attr_accessor :page, :pages, :records
  def initialize(arr = [], opts = {})
   self.page = opts.delete(:page) || opts.delete("page")
   self.pages = opts.delete(:pages) || opts.delete("pages")
   self.records = opts.delete(:records) || opts.delete("records")
   super(arr, opts)
  end

  def params
   {:pages => pages, :page => page, :records => records, :type => type, :error => error, :message => message}
  end
end
class Axapta
 include ActiveModel
 include ActiveModel::Serialization

  def self.parse_err(err) #raise when returned true?
   if err
    p "---parserr", err
    if [1,2,6].include?(err["type"])
     return {:type => AxaptaState::WARN, :error => err["type"], :message => err["message"]}
    else
     return {:type => AxaptaState::FATAL, :error => err["type"], :message => err["message"]}
    end
   else
    return {:type => AxaptaState::OK, :error => nil, :message => nil}
   end
  end

  def self.parse_exc(e, klas = "")
   if klas =~ /JsonRpcClient::ServiceError/
    Rails.logger.info("---exc-parse #{e.to_s}")
    @last_parsed_error = ActiveSupport::JSON.decode(e.to_s.scan(/JSON-RPC error ::\((.+)\)::.+\{.+\}/)[0][0])
    p "---parsed exc", @last_parsed_error
    get_last_exc
   else
    raise
   end
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
    parse_exc(e.message, e.class.name)
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
   ask(:user_info, args)
  end

  def self.load_child_hashes(hash)
   asks(:user_list, "users", {"user_hash" => hash}).map{|u| u["user_id"] }.map{|u| self.user_info(hash, u) }
   #AxaptaRequest.user_list("user_hash" => hash)["users"].map{|u| u["user_id"] }.map{|u| self.user_info(hash, u) }
  end

  def self.search_names(*args)
   ar = args.as_hash
   ar["query_string"] += '*' if ar.has_key?("query_string") && ar["query_string"].last != '*'
   ar[:query_string] += '*' if ar.has_key?(:query_string) && ar[:query_string].last != '*'
   asks(:search_item_name_h, "items", ar.merge(:user_hash => axapta_hash))
   #hash!
  end

  def self.search_dms_names(*args)
   ar = args.as_hash.merge(:user_hash => axapta_hash)
   ar["query_string"].strip! if ar.has_key?("query_string")
   ar[:query_string].strip! if ar.has_key?(:query_string)
   ar["query_string"] += '*' if ar.has_key?("query_string") && !ar["query_string"].blank? && ar["query_string"].last != '*'
   ar[:query_string] += '*' if ar.has_key?(:query_string) && !ar[:query_string].blank? && ar[:query_string].last != '*'
   asks(:search_item_name_dms_h, "items", ar)
  end

  def self.item_info(*args)
   ar = args.as_hash.merge(:user_hash => axapta_hash)
   ask(:item_info, ar)
  end

  def self.search_analogs(*args)
   return [] unless args.first.has_key?("item_id_search") || args.first.has_key?(:item_id_search)
   srch = args.first["item_id_search"]
   srch = args.first[:item_id_search] unless srch
   res = asks(:search_item_an_h, "items", args.as_hash.merge(:user_hash => axapta_hash))
   AxaptaResults.new.from_prepared(res.select{|i| i.item_id != srch }, res.params)
  end

  def self.retail_price(*args)
   return AxaptaResults.new unless args.first.has_key?("item_id") || args.first.has_key?(:item_id)
   srch = args.first["item_id"]
   srch = args.first[:item_id] unless srch
   res = asks(:retail_price, "prices", args.as_hash.merge(:user_hash => axapta_hash))
   a = {}
   locs = res.sort_by{|l| l.min_qty }[0, 4]
   a.merge!("price1" => locs[0].price, "count1" => locs[0].min_qty) if locs[0]
   a.merge!("price2" => locs[1].price, "count2" => locs[1].min_qty) if locs[1]
   a.merge!("price3" => locs[2].price, "count3" => locs[2].min_qty) if locs[2]
   a.merge!("price4" => locs[3].price, "count4" => locs[3].min_qty) if locs[3]
   a
  end

  def self.make_order(hsh)
   ask(:make_order, hsh.merge(:user_hash => axapta_hash, :main_invent_location => User.current.current_account.invent_location_id))
  end

  def self.create_quotation(hsh)
   ask(:create_quotation, hsh.merge!(:user_hash => axapta_hash))
  end

  def self.sales_handle_add(hsh)
   ask(:sales_handle_add, hsh.merge(:user_hash => axapta_hash))
  end

  #def self.sales_handle_header(hsh)
  # begin
  # AxaptaRequest.sales_handle_header(hsh.merge(:user_hash => axapta_hash))
  # rescue Exception => e
  #  return OpenStruct.new(:total => 0, :page => 0, :records => 0, :items => [], :error => e.to_s)
  # end
  #end

  def self.sales_info(*args)
   sales_info_paged(nil, *args) #.items || []
  end

  def self.sales_info_paged(page, *args)
   prm = {:records_per_page => per_page, :user_hash => axapta_hash, :page_num => (page || args.dup.as_hash[:page] || 1), :order_sales_id => "desc"}.merge(args.dup.as_hash)
   res = ask_pages(:sales_info, page || 1, "sales", prm)
   #res.total = res.pages
   #OpenStruct.new(:items => (res.try(:[], "sales") || []).map do |sale|
   # OpenStruct.new sale
   #end, :total => res.try(:[], "pages") || 1, :page => (page || prm[:page] || 1), :records => res.try(:[], "records") || 0)
  end

  def self.sales_info_all(*args)
   prm = {:user_hash => axapta_hash, :page_num => 1, :order_sales_id => "desc", :records_per_page => 65535}.merge(args.dup.as_hash)
   ask_pages(:sales_info, 1, "sales", prm)
   #OpenStruct.new(:items => (res.try(:[], "sales") || []).map do |sale|
   # OpenStruct.new sale
   #end, :total => res.try(:[], "pages") || 1, :page => 1, :records => res.try(:[], "records") || 0)
  end

  def self.sales_report_all(*args)
   prm = {:user_hash => axapta_hash, :page_num => 1, :records_per_page => 65535}.merge(args.dup.as_hash)
   res = ask_pages(:sales_report, 1, "sales", prm)
   #res = ask_pages(:sales_report, 1, "sales", prm)
   #OpenStruct.new(:items => (res.try(:[], "sales") || []).map do |sale|
   # OpenStruct.new sale
   #end, :total => res.try(:[], "pages") || 1, :page => 1, :records => res.try(:[], "records") || 0)
  end

  def self.sales_lines(*args)
   sales_lines_paged(nil, *args) #.try(:items) || []
  end

  def self.sales_lines_paged(page, *args)
   prm = {:records_per_page => per_page, :user_hash => axapta_hash, :page_num => (page || prm[:page] || 1)}.merge(args.dup.as_hash)
   ask_pages(:sales_lines, page || 1, "sales_lines", prm)
   #res = AxaptaRequest.sales_lines({:user_hash => axapta_hash, :page_num => (page || prm[:page] || 1)}.merge(*args))
   #OpenStruct.new(:items => (res.try(:[], "sales_lines") || []).map do |sale|
   # OpenStruct.new sale
   #end, :total => res.try(:[], "pages") || 1, :page => (page || prm[:page] || 1), :records => res.try(:[], "records") || 0)
  end

  def self.sales_lines_all(*args)
   prm = {:user_hash => axapta_hash, :page_num => 1, :records_per_page => 65535}.merge(args.dup.as_hash)
   ask_pages(:sales_lines, 1, "sales_lines", prm)
   #res = AxaptaRequest.sales_lines({:user_hash => axapta_hash, :page_num => (page || prm[:page] || 1)}.merge(*args))
   #OpenStruct.new(:items => (res.try(:[], "sales_lines") || []).map do |sale|
   # OpenStruct.new sale
   #end, :total => res.try(:[], "pages") || 1, :page => 1, :records => res.try(:[], "records") || 0)
  end

  def self.get_delivery_mode
   ask(:get_dlv_mode, {:user_hash => axapta_hash})
  end

  def self.get_delivery_prognosis(code, lc = nil) #TODO refactor && move to offer::store#fabricate
   locs = {}
   pp = {:location_id => lc}
   rz = asks(:delivery_prognosis, "delivery_prognosis", (pp.merge(:invent_location_id => (lc.nil? ? User.current.current_account.invent_location_id : lc), :item_id => code, :user_hash => axapta_hash))).map{|i| {:date => i.delivery_date, :qty => i.delivery_qty} }
   return { "#{lc.nil? ? User.current.current_account.invent_location_id : lc}" => rz }# unless rz.empty?
   asks(:search_item_name_h, "items", pp.merge(:user_hash => axapta_hash, :item_id_search => code, :show_delivery_prognosis => true)).each do |loc|
    (loc.try(:[], "locations")||[]).each do |dl|
     locs[dl["location_id"]] ||= []
     dl.try(:[], "delivery_prognosis").each do |dlv|
      locs[dl["location_id"]] << {:date => dlv["delivery_date"], :qty => dlv["delivery_qty"]}
     end
    end
   end
   cnt = []
   locs.each do |k, v|
    cnt << v.size
   end
   sz = cnt.max
   return [] if sz < 1
   rez = []
   sz.times do |idx|
    rez << Hash[ locs.map{|k, v| [k, v[idx] ] } ]
   end
   rez.each do |r|
    #r.delete_if{|k, v| v.nil? }
    r.delete_if{|k, v| v.nil? || v == 0 }
   end
   Hash[rez.map{|r| r.empty? ? nil : r }.compact]
  end

  def self.create_invoice(order, send = false)
   ask(:create_invoice, {:user_hash => axapta_hash, :sales_id => order, :send_by_email => send})
  end

  def self.invoice_paym(order, send = false)
   ask(:invoice_paym, {:user_hash => axapta_hash, :sales_id => order, :send_by_email => send})
  end

  def self.invoice_lines(hsh)
   invoice_lines_paged(nil, hsh) #.try(:items) || []
  end

  def self.invoice_lines_all(hsh)
   ask_pages(:invoice_lines, 1, "invoice_lines", {:records_per_page => 65535, :page_num => 1}.merge(hsh).merge(:user_hash => axapta_hash))
   #res = AxaptaRequest.invoice_lines({:records_per_page => 65535, :page_num => 1}.merge(hsh).merge(:user_hash => axapta_hash))
   #OpenStruct.new(:items => (res.try(:[], "invoice_lines") || []).map{|i| OpenStruct.new(i)}, :page => 1, :total =>  res.try(:[], "pages") || 1, :records => res.try(:[], "records") || 0)
  end

  def self.invoice_lines_paged(page, hsh)
   ask_pages(:invoice_lines, page, "invoice_lines", {:records_per_page => per_page, :page_num => (page || hsh[:page] || 1)}.merge(hsh).merge(:user_hash => axapta_hash))
   #res = AxaptaRequest.invoice_lines({:records_per_page => per_page, :page_num => (page || hsh[:page] || 1)}.merge(hsh).merge(:user_hash => axapta_hash))
   #OpenStruct.new(:items => (res.try(:[], "invoice_lines") || []).map{|i| OpenStruct.new(i)}, :page => (page || hsh[:page] || 1), :total =>  res.try(:[], "pages") || 1, :records => res.try(:[], "records") || 0)
  end

  def self.quotation_info(hsh)
   quotation_info_paged(nil, hsh) #.try(:items) || []
  end

  def self.quotation_info_paged(page, hsh)
   ask_pages(:quotation_info, page || 1, "quotations", {:records_per_page => per_page, :page_num => (page || hsh[:page] || 1)}.merge(hsh).merge(:user_hash => axapta_hash))
   #res = AxaptaRequest.quotation_info({:records_per_page => per_page, :page_num => (page || hsh[:page] || 1)}.merge(hsh).merge(:user_hash => axapta_hash))
   #OpenStruct.new(:items => (res.try(:[], "quotations") || []).map{|i| OpenStruct.new(i)}, :page => (page || hsh[:page] || 1), :total =>  res.try(:[], "pages") || 1, :records => res.try(:[], "records") || 0)
  end

  def self.quotation_info_all(hsh)
   ask_pages(:quotation_info, 1, "quotations", {:records_per_page => 65535, :page_num => 1}.merge(hsh).merge(:user_hash => axapta_hash))
   #res = AxaptaRequest.quotation_info({:page_num => 1}.merge(hsh).merge(:user_hash => axapta_hash))
   #OpenStruct.new(:items => (res.try(:[], "quotations") || []).map{|i| OpenStruct.new(i)}, :page => 1, :records_per_page => 65535, :total =>  res.try(:[], "pages") || 1, :records => res.try(:[], "records") || 0)
  end

  def self.quotation_lines(hsh)
   quotation_lines_paged(nil, hsh) #.try(:items) || []
  end

  def self.quotation_lines_paged(page, hsh)
   fix = {:item_name => hsh[:item_name]}
   unless fix[:item_name].blank?
    fix[:item_name] += '*' if fix[:item_name].last != '*'
    fix[:item_name] = "" if fix[:item_name].mb_chars.length < 4
   end
   ask_pages(:quotation_lines, page || 1, "quotations_lines", hsh.merge(:records_per_page => per_page, :page_num => (page || hsh[:page] || 1), :user_hash => axapta_hash).merge(fix))
   #res = AxaptaRequest.quotation_lines(hsh.merge(:records_per_page => per_page, :page_num => (page || hsh[:page] || 1), :user_hash => axapta_hash).merge(fix))
   #OpenStruct.new(:items => (res.try(:[], "quotations_lines") || []).map{|i| OpenStruct.new(i)}, :page => (page || hsh[:page] || 1), :total =>  res.try(:[], "pages") || 1, :records => res.try(:[], "records") || 0)
  end

  def self.sales_handle_header(hsh)
   ask(:sales_handle_header, hsh.merge(:user_hash => axapta_hash))
  end

  def self.sales_handle_edit(hsh)
   ask(:sales_handle_edit, hsh.merge(:user_hash => axapta_hash))
  end

  def self.sales_close_reason_list
   asks(:sales_close_reason_list, "reason_list", {:user_hash => axapta_hash}).map{|x| [x.close_reason_description, x.close_reason_id] } #return [[desc, id]]
  end

  def self.info_cust_balance
   asks(:info_cust_balance, "balance", {:user_hash => axapta_hash})
  end

  def self.application_area_list
   asks(:application_area_list, "area_list", {:user_hash => axapta_hash}).sort_by{|l| l.application_area_name }
  end

  def self.custom_limits
   rs = ask(:info_cust_limits, {:user_hash => axapta_hash})
   AxaptaResult.new(rs.reserve.merge(rs.params))
  end

  def self.info_cust_limits
   lim = ask(:info_cust_limits, {:user_hash => axapta_hash})
   AxaptaResult.new.from_prepared(lim, lim.params)
   #.marshal_dump.inject(OpenStruct.new){|r, (k, v)| r.send(k.to_s + '=', OpenStruct.new(v)) ; r }
  end

  def self.info_cust_trans(hsh)
    asks(:info_cust_trans, "trans", hsh.merge(:records_per_page => per_page, :user_hash => axapta_hash))
  end

  def self.sales_tracking(hsh)
    asks(:sales_tracking, "lines", hsh.merge(:user_hash => axapta_hash))
  end

  def self.search_item_name_quick(mask)
   res = asks(:search_item_name_quick, "items", {:user_hash => axapta_hash, :query_string => mask})
   AxaptaResults.new.from_prepared(res.map{|v| v.item_name }.first(10), res.params)
  end

 private
  def self.ask(method, *args)
   begin
    res, err = AxaptaRequest.send(method, *args)
    p "--err-ask", err
    AxaptaResult.new(res.merge(parse_err(err)))
   rescue Exception => e
    parse_exc(e.message, e.class.name)
    AxaptaResult.new({:type => AxaptaState::INVALID, :error => e.class.name, :message => get_last_exc["_error"]})
   end
  end

  def self.asks(method, items, *args)
   begin
    res, err = AxaptaRequest.send(method, *args)
    p "--err-asks", err
    
    its = items ? res[items] : res
    AxaptaResults.new(its, parse_err(err))
   rescue Exception => e
    parse_exc(e.message, e.class.name)
    AxaptaResults.new([], {:type => AxaptaState::INVALID, :error => e.class.name, :message => get_last_exc["_error"]})
   end
  end

  def self.ask_pages(method, page, items, *args)
   begin
    res, err = AxaptaRequest.send(method, *args)
    p "--err-ask_pages", err
    its = items ? res[items] : res
    AxaptaPages.new(its, {:page => page}.merge(parse_err(err)))
   rescue Exception => e
    parse_exc(e.message, e.class.name)
    AxaptaPages.new([], {:type => AxaptaState::INVALID, :error => e.class.name, :message => get_last_exc["_error"]})
   end
   
  end

  def self.per_page
   Setting.get("table.per_page") || 10
  end

  def self.axapta_hash
   unless User.current
    @last_parsed_error = AxaptaResults([], {:type => AxaptaState::INVALID, :message => "Non-selected user"})
    raise AxaptaError
   end
   unless User.current.current_account
    @last_parsed_error = AxaptaResults([], {:type => AxaptaState::INVALID, :message => "Invalid current account for current user"})
    raise AxaptaError
    
   end
   User.current.current_account.axapta_hash
  end
end

