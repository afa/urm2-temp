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

  def self.renew_structure(hash)
   accnt = Account.find_by_axapta_hash(hash)
   req = self.user_info(hash)
   
   accnt.update_attributes req.delete_if{|k, v| not Account.axapta_attributes.include?(k.to_s) }
   accnt.parent.update_attributes self.user_info(accnt.parent.axapta_hash).delete_if{|k, v| not Account.axapta_attributes.include?(k.to_s) } if accnt.parent
   non_registered = []
   self.load_child_hashes(hash).each do |hsh| 
    acc = Account.find_by_axapta_user_id(hsh["user_id"])
    if acc
     acc.update_attributes req.delete_if{|k, v| not Account.axapta_attributes.include?(k.to_s) }.inject({}){|r, a| r.merge(Account.axapta_renames[a[0]].nil? ? {a[0] => a[1]}: {Account.axapta_renames[a[0]] => a[1]}) }
    else
     non_registered << hsh
    end
   end
  end

  def self.load_child_hashes(hash)
   AxaptaRequest.user_list("user_hash" => hash)["users"].map{|u| u["user_id"] }.map{|u| self.user_info(hash, u) }
  end

  def self.search_item_by_name(name) #search_item_name_h
   
  end
end
