class CartAskMan < CartItem

  def type_name
   ::I18n::t :cart_ask_man
  end

  def self.prepare_code(search) #on find, chg search hash to offers array
   hsh = {:user_id => User.current.id, :product_name => search.name}
   fnd = CartItem.unprocessed.where( hsh ).order("updated_at desc").all
   carts = CartItem.unprocessed.in_cart.where(hsh).order("updated_at desc").all
   carts.reject!{|i| i.amount.nil? or i.amount == 0 }
   amnt = carts.first.try(:amount)
   cart = carts.first
   p_hsh = hsh.merge(:processed => false, :amount => amnt, :comment => cart.try(:comment))
   item = self.setup_for(p_hsh).create(p_hsh)
   item.amount = amnt
   item.save!
   fnd.each{|i| i.destroy }
   search.cart_id = item.id
   search.amount = item.amount
   
  end

  def setup_for(hash)
   self.class.setup_for(hash)
  end

  def self.setup_for(hash)
   self
  end
end
