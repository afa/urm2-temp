require "md5"
module WebUtils
 def self.escape_name(str, scope = '')
  Digest::MD5.hexdigest(scope.concat(str))
  #str.gsub(/[\/<>]/, '_')
 end
end
