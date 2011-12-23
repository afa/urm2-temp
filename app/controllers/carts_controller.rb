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
    v_destroy = WebUtils.parse_bool(hsh[:destroy])
    hsh.reject!{|k,v| k == :destroy or k == 'destroy' }
    if v_destroy
     cart.update_attributes hsh.merge(:amount => 0)
     @changed << [cart.id.to_s, '0']
    else
     cart.update_attributes hsh
    end
   end
   @carts = current_user.cart_items.unprocessed.in_cart.all
   @deliveries = current_user.deliveries
  end

  def destroy
   old = CartItem.where(:user_id => current_user.id).unprocessed.in_cart.find(params[:id])
   #@old.try(:update_attributes, :amount => 0)
   @old = old.id
   @new = old.setup_for(:amount => 0, :max_amount => old.max_amount).copy_on_write(:amount => 0, :cart => old.id)
   @carts = CartItem.where(:user_id => current_user.id).unprocessed.in_cart.all
   respond_with do |format|
    format.js { render :layout => false }
   end
  end

end
