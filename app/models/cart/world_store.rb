module Cart::WorldStore
  def self.included(base)
   base.extend(ClassMethods)
   base.instance_eval do
   end
  end

 module ClassMethods
  def prepare_code(search)
   hsh = {:user_id => User.current.id, :product_link => search.code, :product_name => search.name, :product_rohs => search.rohs, :product_brend => search.brend, :prognosis => search.prognoz, :quantity => search.qty_multiples, :max_amount => search.max_qty}
   fnd = CartItem.unprocessed.where( hsh ).order("updated_at desc").all
   carts = CartItem.unprocessed.in_cart.where(hsh).order("updated_at desc").all
   carts.reject!{|i| i.amount.to_i == 0 }
   cart = carts.first
   p_hsh = hsh.merge(:processed => false, :min_amount => search.min_qty, :offer_params => search.raw_prognosis, :comment => cart.try(:comment), :reserve => cart.try(:reserve), :user_price => cart.try(:user_price), :pick => cart.try(:pick))
   item = self.setup_for(p_hsh).create(p_hsh)
   item.offer_params.merge!(search.raw_prognosis)
   item.amount = carts.first.try(:amount)
   item.save!
   fnd.each{|i| i.destroy }
   search.cart_id = item.id
   search.amount = item.amount
  end

 end

  def setup_for(hash)
   self.class.setup_for(hash)
  end

  def allowed_actions
   %w()
  end

end
