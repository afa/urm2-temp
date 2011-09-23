require "md5"
module WebUtils
 def self.escape_name(str, scope = '')
  scope.concat(Digest::MD5.hexdigest(str))
  #str.gsub(/[\/<>]/, '_')
 end

 def self.parse_bool(str)
  return true if %w(1 T t y Y true).include?(str.to_s)
  false
 end
end
