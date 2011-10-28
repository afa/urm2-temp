class CartsController < ApplicationController
 respond_to :js, :html, :json
  def index
   @cart = CartItem.where(:user_id => current_user.id).unprocessed
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

end
