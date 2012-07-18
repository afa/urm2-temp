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
    :open_sales_lines => [[:item_id, "Номенклатура"], [:rohs, "ROHS"], [:item_name, "Наименование"], [:brend, "Производитель"], [:package_name, "Корпус"], [:sales_qty, "Количество"], [:price, "Цена ед. изм."], [:currency_code, "Валюта"], [:amount, "Сумма"], [:sales_id, "Заказ"], [:nomer_nakladnoy, "Накладная"], [:date_dead_line, "Дата"]],
    :order_lines => [[:rohs, "ROHS"], [:item_name, "Наименование"], [:brend, "Производитель"], [:sales_qty, "Количество"], [:price, "Цена"], [:amount, "Сумма"], [:qty_in_debt, "Поставка"], [:reserve_qty, "Резерв"], [:qty_in_processing, "В обработке складом"], [:qty_receive, "Получено"], [:invoiced_in_total, "Продано"], [:date_dead_line, "Дата готовности"], [:confirmed_dlv_date, "Ожидаемая дата поставки"], [:sales_id, "Заказ"]]
           #Контактное лицо Проект
   }
  }

  def export(format, obj)
   parms = EXPORTABLE_FIELDS[format][obj].transpose
   # p "---export", parms, FORMATTER[format].call(parms[1], User.current.cart_items.unprocessed.in_cart.all.map{|i| parms[0].map{|j| i.send(j) } })
   FORMATTER[format].call(parms[1], User.current.cart_items.unprocessed.in_cart.all.map{|i| parms[0].map{|j| i.send(j) } })
  end

 end
end
