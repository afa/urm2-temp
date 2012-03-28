class Array
 def as_hash
  hsh = {}
  p "array to hash", self
  self.each_slice(2){|i| hsh.merge!(i.first => i.last) }
  p "array to hash rez", hsh
  hsh
 end
end

class Hash
 def as_hash
  p "hash to hash", self
  self
 end
end
