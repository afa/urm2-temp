class QuotationsController < ApplicationController

 respond_to :html, :js
 before_filter :get_filter

  def index
   hsh = params[:filter] || {} 
   @quotations = Axapta.quotation_info(hsh)
  end

=begin
  def new
   @carts = current_user.cart_items.in_cart.unprocessed.all
   @reqs = @carts.partition{|i| i.is_a? CartRequest }[0]
   @nreqs = @carts.partition{|i| i.is_a? CartRequest }[1]
   @deliveries = User.current.deliveries
   respond_with do |format|
    format.js { render :layout => false }
    format.html do
     render
    end
   end
  end

  def create
   @changed = []
   @results = User.current.make_order(params[:date_picker], params[:delivery_type], :order_needed => params[:order_needed], :order_comment => params[:order_comment], :request_comment => params[:request_comment])
   @carts = current_user.cart_items.unprocessed.in_cart.all
  end
=end

  def lines
   hsh = params[:filter] || {}
   @lines = Axapta.quotation_lines(hsh)
  end

  def show
   @quotation = Axapta.quotation_lines(:quotation_id => params[:id])#, :only_open => true)
  end


 protected
  def get_filter
   @filter = OpenStruct.new(params[:filter] || {})
  end

end
