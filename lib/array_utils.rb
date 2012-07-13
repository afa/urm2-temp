class Array
 def as_hash
  #rets single hash
  return self.inject({}){|r, i| r.merge(i) } if self.first.is_a? Hash
  hsh = {}
  self.each_slice(2){|i| hsh.merge!(i.first => i.last) }
  hsh
 end
end

class Hash
 def as_hash
  self
 end
end
