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
   res = AxaptaRequest.search_item_name_dms_h(*args).try(:[], "items") || []
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
end
