class CartsController < ApplicationController
 respond_to :js, :html, :json
  def index
   @carts = CartItem.where(:user_id => current_user.id).unprocessed.in_cart.all
  end

  def new
  end

  def create
   @changed = []
   if params[:items] and !params[:items].blank?
    params[:items].reject{|k, v| k == :commit }.reject{|k, v| v[:amount].blank? }.each do |k, v|
     @changed << [v[:cart], CartStore.copy_on_write(v)]
    end
    if params[:dms]
     params[:dms].reject{|k, v| v[:amount].blank? }.each do |k, v|
      @changed << [v[:cart], CartWorld.copy_on_write(v)]
     end
    end
    CartItem.uncached do
     @carts = current_user.cart_items.unprocessed.in_cart.all
     #@carts = CartItem.where(:user_id => current_user.id).unprocessed.in_cart.all
    end
    #redirect_to carts_path
    respond_with do |format|
     format.json do
      #render :json => {:dms => render_to_string( :partial => "main/dms_block.html", :locals => {:items => @items, :after => @after} ), :gap => render_to_string( :partial => "main/gap_line.html", :locals => {:after => @after}), :empty => render_to_string(:partial => "main/dms_empty.html", :locals => {:after => @after})}
     end
     format.js { render :layout => false }
     format.html do
      redirect_to carts_path
     end
    end
   else
    redirect_to :back
   end
  end

  def edit
  end

  def update
   cart = current_user.cart_items.find(params[:id])
   cart.update_attributes params[:cart_item]
  end

  def save
   @changed = []
   carts = params[:cart_item].keys.map{|i| CartItem.find i }
   carts.each do |cart|
    hsh = params[:cart_item][cart.id.to_s]
    p hsh
    act = hsh[:action]
    if act
     case act
      when "pick"
       hsh.merge(:pick => true, :reserve => false)
      when "reserve"
       hsh.merge(:pick => false, :reserve => true)
      else
       hsh.merge(:pick => false, :reserve => false)
     end
    end
    [:destroy, :pick, :reserve].each{|s| hsh[s] = WebUtils.parse_bool(hsh[s]) if hsh.has_key?(s) }
    p hsh
    v_destroy = hsh[:destroy]
    hsh.reject!{|k,v| k == :destroy or k == 'destroy' }
    if v_destroy
     cart.update_attributes hsh.merge(:amount => 0)
     @changed << [cart.id.to_s, '0']
    else
     cart.update_attributes hsh
     @changed << [cart.id.to_s, cart.amount.to_s]
    end
   end
   @carts = User.current.cart_items.unprocessed.in_cart.all
   @deliveries = User.current.deliveries
  end

  def destroy
   old = CartItem.where(:user_id => current_user.id).unprocessed.in_cart.find(params[:id])
   #@old.try(:update_attributes, :amount => 0)
   @old = old.id
   @new = old.setup_for(:amount => 0, :max_amount => old.max_amount).copy_on_write(:amount => 0, :cart => old.id)
   @carts = User.current.cart_items.unprocessed.in_cart.all
   @deliveries = User.current.deliveries
   respond_with do |format|
    format.js { render :layout => false }
    format.json { render :json => {:carts_table => "", :old => @old, :new => @new, :carts_empty => @carts.empty?} }
   end
  end

end
