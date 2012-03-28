class Array
 def as_hash
  #rets single hash
  if self.first.is_a? Hash
   p "array hashes to hash", self
   hsh = self.inject({}){|r, i| r.merge(i) }
   p "array hashes to hash rez", hsh
   return hsh
  end
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
