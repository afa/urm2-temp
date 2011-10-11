class OrdersController < ApplicationController
  def index
   @orders = Axapta.sales_info(:user_hash => current_user.current_account.axapta_hash)
  end

  def show
   @order = Axapta.sales_lines(:sales_id => params[:id], :user_hash => current_user.current_account.axapta_hash)
  end

end
