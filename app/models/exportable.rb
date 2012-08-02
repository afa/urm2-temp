#coding: UTF-8
module Exportable
 def self.included(base)
  base.extend(ClassMethods)
 end
 
 module ClassMethods
   FORMATTER = {
   :csv => proc {|hdr, data|
    out = CSV.generate( {:col_sep => ";"}) do |csv|
     csv << hdr
     data.each{|i| csv << i }
    end
    out.force_encoding('UTF-8').encode('Windows-1251')
   }
  }

  EXPORTABLE_FIELDS = {
   :csv => {
    :cart =>[
     [:type, "Тип"], [:product_name, "Наименование"], [:product_brend, "Производитель"], [:product_rohs, "ROHS"], [:current_price, "Цена"], [:amount, "Количество"], [:location_link, "Склад"], [:prognosis, "Прогноз"], [:comment, "Примечание"], [:requirement, "Requirement"], [:user_price, "Цена клиента"], [:application_area_mandatory, "Требовать указать применение"], [:action, "Действие"]
    ],
    :open_client_lines => [[:item_id, "Номенклатура"], [:rohs, "ROHS"], [:item_name, "Наименование"], [:brend, "Производитель"], [:package_name, "Корпус"], [:sales_qty, "Количество"], [:price, "Цена ед. изм."], [:currency_code, "Валюта"], [:amount, "Сумма"], [:sales_id, "Заказ"], [:nomer_nakladnoy, "Накладная"], [:date_dead_line, "Дата"]],
    :order_lines => [[:rohs, "ROHS"], [:item_name, "Наименование"], [:brend, "Производитель"], [:sales_qty, "Количество"], [:price, "Цена"], [:amount, "Сумма"], [:qty_in_debt, "Поставка"], [:reserve_qty, "Резерв"], [:qty_in_processing, "В обработке складом"], [:qty_receive, "Получено"], [:invoiced_in_total, "Продано"], [:date_dead_line, "Дата готовности"], [:confirmed_dlv_date, "Ожидаемая дата поставки"], [:sales_id, "Заказ"]],
           #Контактное лицо Проект
    :sales => [[:this_sales_origin, "УРМ"], [:sales_id, "Номер заказа"], [:official_number, "Офиц. номер"], [:amount, "Сумма"], [:sales_date, "Дата создания"], [:sales_status, "Статус"], [:comment, "Примечание"], [:contactperson_name, "Контактное лицо"], [:date_dead_line_delivery, "Дата готовности"], [:delivery_mode, "Код способа доставки"], [:document_number, "Счет"], [:sales_amount, "Сумма по счету"]],
    :quotations => [[:this_sales_origin, "УРМ"], [:quotation_id, "Номер запроса"], [:cust_account, "Код клиента"], [:quotation_date, "Дата создания"], [:prognosis_date, "Прогноз"], [:comment, "Примечание"], [:quotation_status, "Статус"], [:sales_responsible, "Менеджер"], [:contact_person_name, "Контактное лицо"]],
    :order_control => [[:item_id, "Код номенклатуры"], [:item_name, "Наименование"], [:brend, "Производитель"], [:sales_qty, "Количество"], [:amount, "Сумма"], [:reserve_qty, "Зарезервировано"], [:reservation_end, "Разрезервировать"], [:sales_id, "Заказ"]], #Web Контактное лицо Менеджер
    :balance => [[:trans_date, "Дата"], [:voucher, ""], [:trans_type, ""], [:document_number, ""], [:company_code, ""], [:currency_code, ""], [:debet_amount_cur, ""], [:credit_amount_cur, ""], [:amount, ""], [:balance_amount_cur, ""], [:common_balance_amount_cur, ""], [:balance_amount, ""], [:common_balance_amount, ""]]
    %td.text-right= tr.credit_amount_cur
    %td.text-right= tr.amount
    %td.text-right= tr.balance_amount_cur
    %td.text-right= tr.common_balance_amount_cur
    %td.text-right= tr.balance_amount
    %td.text-right= tr.common_balance_amount
   %th Дата
   %th Операция
   %th Тип операции
   %th Документ
   %th Фирма
   %th Валюта
   %th Приход в валюте
   %th Расход в валюте
   %th Сумма
   %th Баланс в валюте
   %th Общий баланс в валюте
   %th Баланс
   %th Общий баланс
   }
  }

  def export(format, obj, arr)#User.current.cart_items.unprocessed.in_cart.all
   parms = EXPORTABLE_FIELDS[format][obj].transpose
   # p "---export", parms, FORMATTER[format].call(parms[1], User.current.cart_items.unprocessed.in_cart.all.map{|i| parms[0].map{|j| i.send(j) } })
   FORMATTER[format].call(parms[1], arr.map{|i| parms[0].map{|j| i.send(j) } })
  end

 end
end
