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
    ]
   }
  }

  def export(format, obj)
   parms = EXPORTABLE_FIELDS[format][obj].transpose
   # p "---export", parms, FORMATTER[format].call(parms[1], User.current.cart_items.unprocessed.in_cart.all.map{|i| parms[0].map{|j| i.send(j) } })
   FORMATTER[format].call(parms[1], User.current.cart_items.unprocessed.in_cart.all.map{|i| parms[0].map{|j| i.send(j) } })
  end

 end
end
