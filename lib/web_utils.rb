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

module HumanizedBool
 module True
  def human_readable
   I18n.t :tr_yes
  end
 end
 module False
  def human_readable
   I18n.t :tr_no
  end
 end
 module Nil
  def human_readable
   I18n.t :tr_no
  end
 end
end

class TrueClass
 include HumanizedBool::True
end
class FalseClass
 include HumanizedBool::False
end
class NilClass
 include HumanizedBool::Nil
end
