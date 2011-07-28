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

  def self.user_info(hash, axapta_user_id = nil)
   args = {"user_hash" => hash}
   args.merge!("user_id" => axapta_user_id) if axapta_user_id
   AxaptaRequest.user_info(args)
  end

  def self.renew_structure(hash)
   accnt = Account.find_by_axapta_hash(hash)
   req = self.user_info(hash)
   
   accnt.update_attributes req.delete_if{|k, v| not Account.axapta_attributes.include?(k.to_s) }
   accnt.parent.update_attributes self.user_info(accnt.parent.axapta_hash).delete_if{|k, v| not Account.axapta_attributes.include?(k.to_s) } if accnt.parent
   
   #p req.delete_if{|k, v| %w(blocked business empl_name empl_email contact_email contact_first_name contact_last_name contact_middle_name parent_user_id user_name).include?(k) }
  end

end
