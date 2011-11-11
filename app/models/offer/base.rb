require "web_utils"
#offer_code = WebUtils.escape_name("#{items_line["item_name"]}_#{items_line["item_brend"]}_#{items_line["rohs"]}_#{items_line["location_id"]}")
class Offer::Base
 include ActiveModel
 include ActiveModel::Serialization
 include ActiveModel::Validations
 def attributes
  @attributes ||= {}
 end

  attr_accessor :code, :name, :brend, :rohs

  SIGNATURE_FIELDS = [:code, :name, :brend, :rohs]

  

  def base_signature
   WebUtils.escape_name([:code, :name, :brend, :rohs].map{|a| send(a) }.join('_'))
  end

  def signature
   WebUtils.escape_name(SIGNATURE_FIELDS.map{|a| send(a) }.join('_'))
  end

  def initialize
   super
   if block_given?
    yield self
   end
  end
end
