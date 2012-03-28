class Array
 def as_hash
  hsh = {}
  self.each_slice(2){|i| hsh.merge!(i.first => i.last) }.inject({}){|r, i| r.merge(i) }
  hsh
 end
end

