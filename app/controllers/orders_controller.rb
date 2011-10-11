class OrdersController < ApplicationController
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

# class: cmpECommerceSalesList
# input: 
#   invoice_paym: 
#     description: "фильтр по номеру счёта на оплату"
#     setter: setInvoice4PaymId
#   official_number: 
#     description: "фильтр по официальному номеру заказа"
#     setter: setdocumentNumber
#   only_my: 
#     description: "фильтр. только заказы этого пользователя."
#     setter: setOnlyMy
#   order_sales_date: 
#     description: "сортировка дате заказа (\"asc\"/\"desc\")"
#     setter: setOrderSalesDate
#   order_sales_id: 
#     description: "сортировка по коду заказа (\"asc\"/\"desc\")"
#     setter: setOrderSalesId
#   page_num: 
#     setter: setPageNum
#     title: "номер страницы"
#   records_per_page: 
#     setter: serRecordsPerPage
#     title: "количество строк на странице"
#   sales_id: 
#     setter: setSalesId
#     title: "код заказа"
#   show_external_invoice_num: 
#     description: "флаг. показывать номер накладной транспортной компании."
#     setter: setShowExternalNumberInvoice
#   show_max_quotation_prognosis: 
#     description: "флаг. показывать Срок поставки ( максимальный прогноз по строкам )"
#     setter: setShowMaxQuotationPrognosisId
#   status_filter: 
#     description: "фильтр по статусу заказа"
#     setter: setstatusFilter
#     type: status_filter
#   this_sales_origin: 
#     description: "флаг-фильтр. если установлен, фильтруется по источнику заказа этого пользователя"
#     setter: setthisSalesOrigin
#   user_hash: 
#     description: "Уникальный ключ пользователя, выдается при подключении"
#     mandatory: true
#     maxlen: 32
#     minlen: 32
#     setter: setcmpHashCode
#     title: "Ключ пользователя"
#     type: string
# output: 
#   pages: 
#     getter: getPageCnt
#     title: "Количество страниц в результатах поиска"
#   records: 
#     getter: getRecordCnt
#     title: "Количество записей в результатах поиска"
#   sales: 
#     content: 
#       bank_account: 
#         getter: getBankAccount
#         title: "Расчётный счёт"
#       company_code: 
#         getter: getCompanyCode
#         title: Фирма
#       currency_code: 
#         getter: getCurrencyCode
#         title: Валюта
#       date_dead_line_delivery: 
#         getter: getdateDeadLineDelivery
#         title: "Ожидаемая дата готовности"
#         type: date
#       delivery_mode: 
#         getter: getCustDlvModeId
#         title: "Способ поставки"
#       document_number: 
#         getter: getDocumentNumber
#         title: "Счёт на оплату"
#       external_invoice_num: 
#         getter: getExternalNumberInvoice
#         title: "Накладная ТК"
#       max_quotation_prognosis: 
#         getter: getMaxQuotationPrognosisId
#         title: "Срок поставки"
#       paym_mode: 
#         getter: getPayment
#         title: "Способ оплаты"
#       payment_status: 
#         getter: getPaymentStatus
#         title: "Статус оплаты"
#       sales_amount: 
#         getter: getInvoice4PaymAmount
#         title: "Сумма заказа (по счёту)"
#       sales_date: 
#         getter: getSalesDate
#         title: "Дата заказа"
#         type: date
#       sales_ecommerce_status: 
#         getter: getECommerceStatus
#         title: "Статус в СОД"
#       sales_id: 
#         getter: getSalesId
#         maxlen: 20
#         title: "Номер заказа"
#         type: string
#       sales_status: 
#         getter: getSalesStatus
#         title: Статус
#     iterator: nextOutputLine
#     title: "Cписок заказов"
#     type: array
  end

  def show
   @order = Axapta.sales_lines(:sales_id => params[:id], :user_hash => current_user.current_account.axapta_hash)
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

end
