class CartItem < ActiveRecord::Base
 class CartParamRequired < StandardError; end
 belongs_to :user
 scope :unprocessed, where(:processed => false)
 scope :in_cart, where(:draft => false)

  def type_name
   "Base"
  end

  def offers(count) #ret hash product
   raise "NYI"
  end

  def self.prepare_for(count, hsh)
   raise "NYI"
  end

  def self.copy_on_write(hsh) # excpshn on bad params, not found
   raise CartParamRequired unless hsh.try(:[], :cart)
   old = find(hsh[:cart])
   puts "old offer"
   p old
   if hsh[:amount].to_i != old.amount
    puts "ammount #{hsh[:amount]}"
    offers = old.offers(hsh[:amount].to_i)
    p offers
    new_hsh = old.class.prepare_for(hsh[:amount].to_i, offers)
    instance_eval(new_hsh[:type]).create(new_hsh.reject{|k, v| k == :type }.update(:draft => !(new_hsh.amount.to_i > 0)))
    old.destroy!
   end
   
  end
end
