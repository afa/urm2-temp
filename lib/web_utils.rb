require "digest/md5"
module WebUtils
 def self.escape_name(str, scope = '')
  scope.concat(Digest::MD5.hexdigest(str))
  #str.gsub(/[\/<>]/, '_')
 end

 def self.parse_bool(str)
  return true if %w(1 T t y Y true).include?(str.to_s)
  false
 end

 def self.to_bool(val)
  ActiveRecord::ConnectionAdapters::Column.value_to_boolean(val)
 end
end

module WebSignature
  def base_signature
   WebUtils.escape_name(self.class.base_signature_fields.map{|a| send(a) }.join('_'))
  end

  def signature
   WebUtils.escape_name(self.class.signature_fields.map{|a| send(a) }.join('_'))
  end
end
