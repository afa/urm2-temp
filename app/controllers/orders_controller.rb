class OrdersController < ApplicationController

 respond_to :html, :js
 before_filter :get_filter

  def index
   @orders = Axapta.sales_info_paged(@page, {:user_hash => current_user.current_account.axapta_hash}.merge(@filter_hash))
  end

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
   gon.need_application = @carts.detect{|i| i.application_area_mandatory }
   @app_list = Axapta.application_area_list || []
   gon.app_list = @app_list

  end

  def lines
   @lines = Axapta.sales_lines_paged(@page, @filter_hash.merge(:only_open => true))
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
=begin
1. Добавить запрос - "Список причин закрытия заказа".

Наименование: sales_close_reason_list

Входные данные: нет

Выходные данные:

Массив причин отказов, для каждого два поля: код (close_reason_id) и описание (close_reason_description), данные брать из справочника "Причины предложения", smmQuotationReasonGroup по условиям не "Блокировано" и не "Причина для регламента" с сортировкой по полю "Приоритет" - см. EPSalesTableInfoRBA -> WebUserDefined:CloseSaleReasonId -> layout - общий для УРМ и СОД код вынести из веб-формы.

2. В запрос sales_handle_header добавить параметр "Причина закрытия" close_reason_id.

При установке - производить закрытие заказа как в УРМ, см. EPSalesTableInfoRBA -> WebButton:webCloseSale -> clicked - общий для УРМ и СОД код вынести из веб-формы.

3. В запрос sales_handle_edit добавить параметр "Причина закрытия" close_reason_id.

При установке - производить удаление строки как в УРМ, см. EPSalesTableInfoRBA -> WebButton:WebButtonDelete -> clicked - общий для УРМ и СОД код вынести из веб-формы. Обработку параметра производить после обработки изменения количества и разрезервирования.
=end
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

 protected
  def get_filter
   @filter_hash = params[:filter] || {}
   @filter = OpenStruct.new(@filter_hash)
   @page = params[:page] || 1
  end
end
