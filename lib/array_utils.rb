class Array
 def to_hash
  hsh = {}
  self.each_slice(2){|i| hsh.merge!(i[0] => i[1]) }
  hsh
 end
end
