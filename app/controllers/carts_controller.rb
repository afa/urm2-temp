class CartsController < ApplicationController
 respond_to :js, :html, :json
  def index
   @cart = CartItem.where(:user_id => current_user.id).unprocessed.in_cart.all
  end

  def new
  end

  def create
   if params[:items][:commit]
    params[:items].reject{|k, v| k == :commit }.reject{|k, v| v[:amount].blank? }.each do 
    end
    redirect_to carts_path
   end
   redirect_to :back
  end

  def edit
  end

  def update
  end

end
