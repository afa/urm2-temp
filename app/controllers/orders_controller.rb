class OrdersController < ApplicationController

 respond_to :html, :js
 before_filter :get_filter

  def index
   @orders = Axapta.sales_info_paged(@page, {:user_hash => current_user.current_account.axapta_hash}.merge(@filter_hash))
# Фильтры:

# Номер заказа: текстовая строка, params.sales_id
# Оф. номер счета: текстовая строка, params.official_number
# Только УРМ: вкл/выкл, params.this_sales_origin
# Только мои заказы: вкл/выкл, params.only_my

# "УРМ": todo (this_sales_origin)
# "Номер заказа": result.sales[].sales_id
# "Офиц. номер": todo (official_number)
# "Сумма": todo (amount?)
# "Статусы строк заказа" --
# "Трекинг" --
# "Дата создания": result.sales[].sales_date
# "Статус": result.sales[].sales_status todo - в enum
# "Примечание": todo (comment)
# "Контактное лицо": todo (имя contactperson_name)
# "Заявка на склад": todo (да/нет)
# "Дата готовности": result.sales[].date_dead_line_delivery
# "Код способа поставки": result.sales[].delivery_mode
# "Cчет": result.sales[].document_number
# "Сумма по счету": result.sales[].sales_amount
# "Менеджер" --
# "Вид оплаты" --
# "Накладная" --

  end

=begin
Заказ

Инф. блок о заказе

Редактирование:
    Строки: Примечание, Требования sales_handle_edit
    Комментарий: sales_handle_header

Обработка
    Заказ
        Выставление счета
            Создать и/или Отправить (3 варианта)
            [Go]
        Закрыть заказ
            Выбор причины закрытия
            [Закрыть]            
    Строки
        Резервирование
            Количество по строкам для обработки
            [Резервировать]
            [Разрезервировать все]
        Бронь
            Количество по строкам для обработки
            Параметры бронирования
            [Бронировать]
        Перенос резерва
            Выбор строк (чекбокс), Заказ для переноса - выбор (20-30)
        Удаление строк
            Выбор строк (чекбокс)        
            Причина удаления
            [Удалить]
        Запрос цены
            Выбор строк (чекбокс)        
            Цена клиента
            [Запросить]
=end

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

  def lines
   @lines = Axapta.sales_lines_paged(@page, @filter_hash.merge(:only_open => true))
  end

  def show
   @reasons = Axapta.sales_close_reason_list
   @order_info = Axapta.sales_info(:sales_id => params[:id], :show_external_invoice_num => true, :show_max_quotation_prognosis => true).first
   @lines = Axapta.sales_lines_paged(@page, :sales_id => params[:id], :show_reserve_qty => true)#, :only_open => true)
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
   Axapta.sales_handle_edit(:sales_lines => lines.map{|k, v| v.merge(:item_id => k) }, :sales_id => id) #TODO fix item_id for line_id
   redirect_to order_path(id)
  end

  def close
   id = params[:id]
   reason = params.try(:[], :order).try(:[], id).try(:[], :close_reason_id)
   unless reason
    redirect_to order_path(id), :flash => {:error => "empty reason"}
    return
   end
   Axapta.sales_handle_header(:close_reason_id => reason, :sales_id => id)
   redirect_to order_path(id)
  end

  def reserve
   id = params[:id]
   lines = params.try(:[], :order).try(:[], id).try(:[], :line) || []
   if lines.empty?
    redirect_to order_path(id), :flash => {:error => "empty lines"}
    return
   end
   Axapta.sales_handle_edit(:sales_lines => lines.map{|k, v| v.merge(:item_id => k, :is_reserv => 1) }, :sales_id => id) #TODO fix item_id for line_id
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
   Axapta.sales_handle_edit(:sales_lines => lines.select{|v| v.reserve_qty > 0 }.map{|v| {:item_id => v.item_id, :process_qty => -v.reserve_qty, :is_reserv => 1} }, :sales_id => id) #TODO fix item_id for line_id
   redirect_to order_path(id)
  end

  def pick
   id = params[:id]
   lines = params.try(:[], :order).try(:[], id).try(:[], :line) || []
   if lines.empty?
    redirect_to order_path(id), :flash => {:error => "empty lines"}
    return
   end
   Axapta.sales_handle_edit(:sales_lines => lines.map{|k, v| v.merge(:item_id => k, :is_pick => 1) }, :sales_id => id, :date_dead_line => params.try(:[], :order).try(:[], id).try(:[], :date_picker), :customer_delivery_type_id => params.try(:[], :order).try(:[], id).try(:[], :delivery_type)) #TODO fix item_id for line_id
   redirect_to order_path(id)
  end

 protected
  def get_filter
   @filter_hash = params[:filter] || {}
   @filter = OpenStruct.new(@filter_hash)
   @page = params[:page] || 1
  end
end
