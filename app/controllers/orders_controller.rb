class OrdersController < ApplicationController

 respond_to :html, :js
 before_filter :get_filter

  def index
   @orders = Axapta.sales_info_paged(@page, {:user_hash => current_user.current_account.axapta_hash}.merge(@filter_hash))
  end

  def new
   @carts = current_user.cart_items.in_cart.unprocessed.order("product_name, product_brend").all
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
   @carts = current_user.cart_items.unprocessed.in_cart.order("product_name, product_brend").all
   @stores = @carts.map(&:location_link).uniq.compact.sort{|a, b| a == User.current.current_account.invent_location_id ? -1 : a <=> b }
   gon.need_application = @carts.detect{|i| i.application_area_mandatory }
   @app_list = Axapta.application_area_list || []
   gon.app_list = @app_list
   gon.carts = render_to_string :partial => "carts/cart_line", :locals => {:app_list => @app_list}, :collection => @carts
   res = []
   @results[0].each{|r| res << {:name => "info", :value => "#{t :created_orders} #{r[0]}"} } if @results[0]
   res << {:name => "info", :value => "#{t :created_quotations} #{@results[1]}"} if @results[1]
   gon.results = res
   gon.redirect_to = quotation_path(@results[1]) if @results[1]
   gon.redirect_to = order_path(@results[0][0]) if @results[0] && @results[0][0]
  end

  def lines
   @lines = Axapta.sales_lines_paged(@page, @filter_hash.merge(:only_open => true))
  end

  def client_lines
   @lines = Axapta.sales_lines_paged(@page, @filter_hash.merge(:only_open => true)) #fix when made request
   @filter.date_to = Date.current.strftime("%Y-%m-%d") if @filter.date_to.blank?
   @filter.date_from = 1.month.ago.strftime("%Y-%m-%d") if @filter.date_from.blank?
  end

  def control
   @info = Axapta.custom_limits
   @lines = Axapta.sales_lines_paged(@page, @filter_hash.merge(:only_reserve => true, :show_reserve_qty => true))
  end

  def show
   @close_reasons = Axapta.sales_close_reason_list
   @order_info = Axapta.sales_info(:sales_id => params[:id], :show_external_invoice_num => true, :show_max_quotation_prognosis => true).first
   @lines = Axapta.sales_lines_paged(@page, :sales_id => params[:id], :show_reserve_qty => true, :show_status_qty => true)#, :only_open => true)
   @deliveries = current_user.deliveries
  end

  def save
   id = params[:id]
   lines = params.try(:[], :order).try(:[], id).try(:[], :line) || []
   if lines.empty?
    redirect_to order_path(id), :flash => {:error => "empty lines"}
    return
   end
   comment = params[:order][id][:comment]
   #@order = Axapta.sales_info(:sales_id => id.to_i)
   #@lines = Axapta.sales_lines(:sales_id => id.to_i)
   Axapta.sales_handle_header(:comment => comment, :sales_id => id)
   Axapta.sales_handle_edit(:sales_lines => lines.map{|k, v| v.merge(:line_id => k).merge(:requirements => v[:requirement]) }, :sales_id => id) #TODO fix line_id for line_id
   redirect_to order_path(id)
  end

  def invoice
   id = params[:id]
   idx = %w(make send make_send).index(params[:order].try(:[], id).try(:[], :order_action) || "")
   unless idx
    redirect_to root_path, :flash => {:error => "invalid req"}
    return
   end
   if [0, 2].include?(idx)
    begin
     Axapta.create_invoice(id, idx == 2)
    rescue AxaptaError
     redirect_to order_path(id), :flash =>{:error => Axapta.get_last_exc["_error"]["message"]}
     return
    end
   else
    begin
     Axapta.invoice_paym(id, true)
    rescue AxaptaError
     redirect_to order_path(id), :flash =>{:error => Axapta.get_last_exc["_error"]["message"]}
     return
    end
   end
   redirect_to order_path(id)
  end

  def close
   id = params[:id]
   reason = params.try(:[], :order).try(:[], id).try(:[], :close_reason_id)
   unless reason
    redirect_to order_path(id), :flash => {:error => "empty reason"}
    return
   end
   begin
    Axapta.sales_handle_header(:close_reason_id => reason, :sales_id => id)
   rescue AxaptaError
    redirect_to order_path(id), :flash =>{:error => Axapta.get_last_exc["_error"]["message"]}
    return
   end
   redirect_to order_path(id)
  end

  def reserve
   id = params[:id]
   lines = params.try(:[], :order).try(:[], id).try(:[], :line) || []
   if lines.empty?
    redirect_to order_path(id), :flash => {:error => "empty lines"}
    return
   end
   begin
    Axapta.sales_handle_edit(:sales_lines => lines.map{|k, v| v.merge(:line_id => k, :is_reserv => 1) }, :sales_id => id) #TODO fix line_id for line_id
   rescue AxaptaError
    redirect_to order_path(id), :flash =>{:error => Axapta.get_last_exc["_error"]["message"]}
    return
   end
   redirect_to order_path(id)
  end

  def unreserve
   id = params[:id]
   lines = Axapta.sales_lines(:sales_id => id, :show_reserve_qty => true)#, :only_open => true)
   #lines = params.try(:[], :order).try(:[], id).try(:[], :line) || []
   if lines.empty?
    redirect_to order_path(id), :flash => {:error => "empty lines"}
    return
   end
   begin
    Axapta.sales_handle_edit(:sales_lines => lines.select{|v| v.reserve_qty > 0 }.map{|v| {:line_id => v.line_id, :process_qty => -v.reserve_qty, :is_reserv => 1} }, :sales_id => id) #TODO fix line_id for line_id
   rescue AxaptaError
    redirect_to order_path(id), :flash =>{:error => Axapta.get_last_exc["_error"]["message"]}
    return
   end
   redirect_to order_path(id)
  end

  def pick
   id = params[:id]
   lines = params.try(:[], :order).try(:[], id).try(:[], :line) || []
   if lines.empty?
    redirect_to order_path(id), :flash => {:error => "empty lines"}
    return
   end
   begin
    Axapta.sales_handle_edit(:sales_lines => lines.map{|k, v| v.merge(:line_id => k, :is_pick => 1) }, :sales_id => id, :date_dead_line => params.try(:[], :date_picker), :customer_delivery_type_id => params.try(:[], :delivery_type)) #TODO fix line_id for line_id
   rescue AxaptaError
    redirect_to order_path(id), :flash =>{:error => Axapta.get_last_exc["_error"]["message"]}
    return
   end
   redirect_to order_path(id)
  end

  def erase
   id = params[:id]
   lines = params.try(:[], :order).try(:[], id).try(:[], :line) || []
   if lines.empty?
    redirect_to order_path(id), :flash => {:error => "empty lines"}
    return
   end
   begin
    Axapta.sales_handle_edit(:sales_lines => lines.map{|k, v| v.merge(:line_id => k, :close_reason_id => params.try(:[], :order).try(:[], id).try(:[], :close_reason_id)) }, :sales_id => id) #TODO fix line_id for line_id
   rescue AxaptaError
    redirect_to order_path(id), :flash =>{:error => Axapta.get_last_exc["_error"]["message"]}
    return
   end
   redirect_to order_path(id)
  end

  def export_client_lines #fix when made request
   respond_with do |format|
    format.csv do
     send_data CartItem.export(:csv, :client_lines, Axapta.sales_lines_all(@filter_hash.merge(:only_open => true)).items), :type => "application/csv", :disposition => :attachment
    end
   end
   
  end

  def export_lines
   respond_with do |format|
    format.csv do
     send_data CartItem.export(:csv, :order_lines, Axapta.sales_lines_all(@filter_hash.merge(:only_open => true)).items), :type => "application/csv", :disposition => :attachment
    end
   end
   
  end

  def export_control
   respond_with do |format|
    format.csv do
     send_data CartItem.export(:csv, :order_control, Axapta.sales_lines_all(@filter_hash.merge(:only_reserve => true, :show_reserve_qty => true)).items), :type => "application/csv", :disposition => :attachment
    end
   end
   
  end

  def export_list
   respond_with do |format|
    format.csv do
     send_data CartItem.export(:csv, :sales, Axapta.sales_info_all(@filter_hash).items), :type => "application/csv", :disposition => :attachment
    end
   end
  end

 protected
  def get_filter
   @filter_hash = params[:filter] || {}
   if @filter_hash[:this_sales_origin].blank?
    @filter_hash[:this_sales_origin]='0'
   end
   @filter = OpenStruct.new(@filter_hash)
   @page = params[:page] || 1
  end
end
