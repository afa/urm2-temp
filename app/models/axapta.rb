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
   #non_registered = []
   self.load_child_hashes(hash).each do |hsh|
    acc = Account.find_by_axapta_user_id(hsh["user_id"])
    #if acc
     acc.update_attributes self.filter_account_attributes(hsh) if acc
    #else
     #non_registered << hsh
    #end
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
   #res = AxaptaRequest.search_item_name_h((*args).map{|k, v| (k.to_s == "search_string" && v.last != "*") ? ( k => v + "*" ) : (k => v) }).try(:[], "items") || []
   #res
  end

  def self.search_dms_names(*args)
   #p "search_dms_names", args
   ar = *args.dup
   ar["query_string"] += '*' if ar.has_key?("query_string") && !ar["query_string"].blank? && ar["query_string"].last != '*'
   ar[:query_string] += '*' if ar.has_key?(:query_string) && !ar[:query_string].blank? && ar[:query_string].last != '*'
   res = AxaptaRequest.search_item_name_dms_h(ar).try(:[], "items") || []
   #res
  end

  def self.item_info(*args)
   ar = *args.dup
   res = AxaptaRequest.item_info(ar) || []
   #res
  end

  def self.search_analogs(*args)
   return [] unless args.first.has_key?("item_id_search") || args.first.has_key?(:item_id_search)
   srch = args.first["item_id_search"]
   srch = args.first[:item_id_search] unless srch
   res = AxaptaRequest.search_item_an_h(*args).try(:[], "items") || []
   res.select{|i| i.has_key?("item_id") && i["item_id"] != srch }
   #res
  end

  def self.retail_price(*args)
   return [] unless args.first.has_key?("item_id") || args.first.has_key?(:item_id)
   srch = args.first["item_id"]
   srch = args.first[:item_id] unless srch
   res = AxaptaRequest.retail_price(*args).try(:[], "items") || []
   a = {}
   locs = res["prices"].sort_by{|l| l["min_qty"] }[0, 4]
   a.merge!("price1" => locs[0]["price"]) if locs[0]
   a.merge!("price2" => locs[1]["price"], "count2" => locs[1]["min_qty"]) if locs[1]
   a.merge!("price3" => locs[2]["price"], "count3" => locs[2]["min_qty"]) if locs[2]
   a.merge!("price4" => locs[3]["price"], "count4" => locs[3]["min_qty"]) if locs[3]
   a
  end

  def self.sales_info(*args)
   begin
    res = AxaptaRequest.sales_info(*args)
   rescue Exception => e
    return []
   end
   (res.try(:[], "sales") || []).map do |sale|
    OpenStruct.new sale
   end
  end

  def self.sales_lines(*args)
   res = AxaptaRequest.sales_lines(*args)
   (res.try(:[], "sales_lines") || []).map do |sale|
    OpenStruct.new sale
   end
  end
end

=begin
--- 
class: cmpECommerce_CreateSalesTable
input: 
  comment: 
    setter: setCmpComment
    type: string
  customer_delivery_type_id: 
    description: "код способа поставки клиента"
    setter: setCustDlvModeRecId
  date_dead_line: 
    setter: setDateDeadLine
    type: date
  disc_percent: 
    setter: setDiscPercent
  is_pick_all: 
    description: "резервируются/бронируются все вновь созданные строки заказа. Ранее существующие строки не обрабатываются."
    setter: setIsPickAll
    type: boolean
  main_invent_location: 
    setter: setMainInventLocationId
  po_url: 
    setter: setPoURL
  reserve_sale: 
    description: "зарезервировать весь заказ"
    setter: setReserveSale
    type: boolean
  sales_auto_process: 
    description: "флаг. установить автоматическую обработку заказа"
    setter: setSalesAutoProcess
    type: boolean
  sales_lines: 
    content: 
      invc_brend_alias: 
        setter: setDMSinvcBrendAlias
      invent_location: 
        setter: setInventLocationId
        title: склад
        type: string
      is_pick: 
        setter: setIsPick
        title: "бронировать строку"
        type: boolean
      item_id: 
        setter: setItemId
        title: "код ном-ры"
        type: string
      item_name: 
        setter: setInvcInventItemName
      line_customer_delivery_type_id: 
        setter: setLineCustDlvMode
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
      qty: 
        setter: setQty
        title: количество
        type: real
      qty_multiples: 
        setter: setDMSqtyMultiples
      reserve_sale: 
        setter: setReserveSale
        type: boolean
      sales_price: 
        description: "необязательное. заполняется для ДМС или для стока, если это разрешено правами."
        setter: setSalesPrice
        title: цена
    iterator: addTmpLine
    title: "строки заказа"
    type: array
  user_hash: 
    description: "Уникальный ключ пользователя, выдается при подключении"
    mandatory: true
    maxlen: 32
    minlen: 32
    setter: setcmpHashCode
    title: "Ключ пользователя"
    type: string
output: 
  sales_id: 
    getter: getResultSalesId
    title: "код созданного заказа"
    type: string
title: "создание заказа"
=end
