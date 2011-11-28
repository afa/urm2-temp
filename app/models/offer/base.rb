require "web_utils"
require "class_attributes_inheritance"
#offer_code = WebUtils.escape_name("#{items_line["item_name"]}_#{items_line["item_brend"]}_#{items_line["rohs"]}_#{items_line["location_id"]}")
class Offer::Base
 include ActiveModel
 include ActiveModel::Serialization
 include ActiveModel::Validations
 include ClassLevelInheritableAttributes
 cattr_inheritable :base_signature_fields, :signature_fields
 def attributes
  @attributes ||= {}
 end

  attr_accessor :code, :name, :brend, :rohs, :cart_id, :amount
  #serialize :addons, Array

  @base_signature_fields = [:code, :name, :brend, :rohs]
  @signature_fields = @base_signature_fields

  

  def base_signature
   WebUtils.escape_name(self.class.base_signature_fields.map{|a| send(a) }.join('_'))
  end

  def signature
   WebUtils.escape_name(self.class.signature_fields.map{|a| send(a) }.join('_'))
  end

  def initialize
   super
   if block_given?
    yield self
   end
  end
end
