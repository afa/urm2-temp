require "md5"
module WebUtils
 def self.escape_name(str)
  Digest::MD5.hexdigest(str)
  #str.gsub(/[\/<>]/, '_')
 end
end
