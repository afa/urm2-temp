class CartsController < ApplicationController
 respond_to :js, :html, :json
  def index
   @cart = CartItem.where(:user_id => current_user.id).unprocessed.in_cart.all
  end

  def new
  end

  def create
   if params[:items].try(:[], :commit)
    params[:items].reject{|k, v| k == :commit }.reject{|k, v| v[:amount].blank? }.each do |k, v|
     CartStore.copy_on_write(v)
    end
    if params[:dms]
     p "---dms create", params[:dms]
     params[:dms].reject{|k, v| v[:amount].blank? }.each do |k, v|
      p "dms order", k, v
      CartWorld.copy_on_write(v)
     end
    end
    redirect_to carts_path
   else
    redirect_to :back
   end
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
