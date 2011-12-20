class OrdersController < ApplicationController

 respond_to :html, :js
 before_filter :get_filter

  def index
   @orders = Axapta.sales_info(:user_hash => current_user.current_account.axapta_hash)
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
   hsh = params[:filter] || {}
   @lines = Axapta.sales_lines(hsh.merge(:user_hash => current_user.current_account.axapta_hash, :only_open => true))
  end

  def show
   @order = Axapta.sales_lines(:sales_id => params[:id], :user_hash => current_user.current_account.axapta_hash)#, :only_open => true)
# 2. Строки заказа
 
# Меню: Заказы - Открытые строки

# Запрос: sales_lines, параметр params.only_open - всегда true

# Фильтры:

# Дата отгрузки: даты c/по (см. календарик в шаблоне 008, compel_html_008/orders.html), params.date_from, params.date_to
# Наименование: строка, params.item_name
# Только мои позиции: вкл/выкл, params.only_my
# Только ДМС: вкл/выкл, params.only_dms
# Таблица:
# 
# "ROHS": sales_lines[].rohs
# "Наименование": sales_lines[].item_name
# "Производитель": sales_lines[].brend
# "Количество": sales_lines[].sales_qty
# "Цена": sales_lines[].price
# "Сумма": sales_lines[].amount
# "Поставка": sales_lines[].qty_in_debt
# "Резерв": sales_lines[].reserve_qty
# "В обработке складом": sales_lines[].qty_in_processing
# "Получено": sales_lines[].qty_receive
# "Продано": sales_lines[].invoiced_in_total
# "Дата готовности": sales_lines[].date_dead_line
# "Ожидаемая дата поставки": sales_lines[].confirmed_dlv_date
# "Заказ": sales_lines[].sales_id
# "Контактное лицо": todo
# "Проект": todo
  end


 protected
  def get_filter
   @filter = OpenStruct.new(params[:filter] || {})
  end
end
