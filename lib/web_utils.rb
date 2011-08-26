module WebUtils
 def self.escape_name(str)
  str.gsub(/[\/<>]/, '_')
 end
end
