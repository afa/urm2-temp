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
   },
   :xls => proc do |hdr, data, opts = {}|
    c_row = 0
    return StringIO.open do |io|
     Spreadsheet::Workbook.new do |book|
      book.create_worksheet do |shit|
       if opts.has_key? :preheader
        opts[:preheader].each do |ln|
         ln.each do |c|
          shit.row(c_row) << c
         end
         c_row += 1
        end
       end
       hdr.each{|c| shit.row(c_row) << c }
       c_row += 1
       data.each do |ln|
        ln.each do |c|
         shit.row(c_row) << c
        end
        c_row += 1
       end

      end
      book.write io
     end
     io.string
    end
   end
  }

  EXPORTABLE_FIELDS = {
   :cart => {:types => [[:type, "Тип"], [:product_name, "Наименование"], [:product_brend, "Производитель"], [:product_rohs, "ROHS"], [:current_price, "Цена"], [:amount, "Количество"], [:location_link, "Склад"], [:prognosis, "Прогноз"], [:comment, "Примечание"], [:requirement, "Requirement"], [:user_price, "Цена клиента"], [:application_area_mandatory, "Требовать указать применение"], [:action, "Действие"]]},
   :open_client_lines => {:types => [[:item_id, "Номенклатура"], [:rohs, "ROHS"], [:item_name, "Наименование"], [:brend, "Производитель"], [:package_name, "Корпус"], [:sales_qty, "Количество"], [:price, "Цена ед. изм."], [:currency_code, "Валюта"], [:amount, "Сумма"], [:sales_id, "Заказ"], [:nomer_nakladnoy, "Накладная"], [:date_dead_line, "Дата"]]},
   :order_lines => {:types => [[:rohs, "ROHS"], [:item_name, "Наименование"], [:brend, "Производитель"], [:sales_qty, "Количество"], [:price, "Цена"], [:amount, "Сумма"], [:qty_in_debt, "Поставка"], [:reserve_qty, "Резерв"], [:qty_in_processing, "В обработке складом"], [:qty_receive, "Получено"], [:invoiced_in_total, "Продано"], [:date_dead_line, "Дата готовности"], [:confirmed_dlv_date, "Ожидаемая дата поставки"], [:sales_id, "Заказ"]]},
           #Контактное лицо Проект
   :sales => {:types => [[:this_sales_origin, "УРМ"], [:sales_id, "Номер заказа"], [:official_number, "Офиц. номер"], [:amount, "Сумма"], [:sales_date, "Дата создания"], [:sales_status, "Статус"], [:comment, "Примечание"], [:contactperson_name, "Контактное лицо"], [:date_dead_line_delivery, "Дата готовности"], [:delivery_mode, "Код способа доставки"], [:document_number, "Счет"], [:sales_amount, "Сумма по счету"]]},
   :quotations => {:types => [[:this_sales_origin, "УРМ"], [:quotation_id, "Номер запроса"], [:cust_account, "Код клиента"], [:quotation_date, "Дата создания"], [:prognosis_date, "Прогноз"], [:comment, "Примечание"], [:quotation_status, "Статус"], [:sales_responsible, "Менеджер"], [:contact_person_name, "Контактное лицо"]]},
   :order_control => {:types => [[:item_id, "Код номенклатуры"], [:item_name, "Наименование"], [:brend, "Производитель"], [:sales_qty, "Количество"], [:amount, "Сумма"], [:reserve_qty, "Зарезервировано"], [:reservation_end, "Разрезервировать"], [:sales_id, "Заказ"]]}, #Web Контактное лицо Менеджер
   :balance => {:types => [[:trans_date, "Дата"], [:voucher, "Операция"], [:trans_type, "Тип операции"], [:document_number, "Документ"], [:company_code, "Фирма"], [:currency_code, "Валюта"], [:debet_amount_cur, "Приход в валюте"], [:credit_amount_cur, "Расход в валюте"], [:amount, "Сумма"], [:balance_amount_cur, "Баланс в валюте"], [:common_balance_amount_cur, "Общий баланс в валюте"], [:balance_amount, "Баланс"], [:common_balance_amount, "Общий баланс"]]},
   :sold_orders => {:types => [[:web, "Интернет портал"], [:sales_id, "Код заказа"], [:chgit, "Номер заказа"], [:rohs, "ROHS"], [:item_name, "Наименование"], [:chgit, "Применение"], [:brend, "Производитель"], [:chgit, "Корпус"], [:chgit, "Кол-во"], [:chgit, "Цена"], [:chgit, "Валюта"], [:chgit, "Сумма"], [:chgit, "Общая скидка в %"], [:chgit, "Скидка по позиции, %"], [:chgit, "Дата продажи"], [:chgit, "Склад отгрузки"], [:chgit, "Документ"], [:chgit, "Оф. номер накладной"], [:chgit, "ГТД"], [:chgit, "Страна происхождения"], [:chgit, "Код страны"], [:chgit, "БИН"], [:chgit, "Код номенклатуры"], [:chgit, "Покупатель"], [:chgit, "Контактное лицо"], [:chgit, "Лот закупки клиента"], [:chgit, "Место"]]}
   }


  def export(format, obj, arr, opts = {})#User.current.cart_items.unprocessed.in_cart.all
   parms = EXPORTABLE_FIELDS[obj][:types].transpose
   # p "---export", parms, FORMATTER[format].call(parms[1], User.current.cart_items.unprocessed.in_cart.all.map{|i| parms[0].map{|j| i.send(j) } })
   FORMATTER[format].call(parms[1], arr.map{|i| parms[0].map{|j| i.send(j) } }, opts)
  end

 end
end
