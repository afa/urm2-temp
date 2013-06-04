class CartWorldAskMan < CartItem
  include Cart::WorldStore

  def self.setup_for(hash)
   return self if hash[:amount].to_i > hash[:max_amount].to_i
   CartWorld
  end
end
