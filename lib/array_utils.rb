class Array
 def as_hash
  hsh = {}
  self.each_slice(2){|i| hsh.merge!(i.first => i.last) }
  hsh
 end
end
