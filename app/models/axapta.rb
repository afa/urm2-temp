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
end
