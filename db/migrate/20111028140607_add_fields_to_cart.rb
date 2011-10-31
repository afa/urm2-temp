class AddFieldsToCart < ActiveRecord::Migration
  def self.up
   add_column :cart_items, :type, :string
   add_column :cart_items, :current_price, :float
   add_column :cart_items, :prognosis, :string
   add_column :cart_items, :quantity, :integer
   add_column :cart_items, :min_amount, :integer
   add_column :cart_items, :max_amount, :integer
   add_column :cart_items, :avail_amount, :integer
   add_column :cart_items, :comment, :text
   add_column :cart_items, :user_price, :float
   add_column :cart_items, :actions, :string
  end

  def self.down
   remove_column :cart_items, :type
   remove_column :cart_items, :current_price
   remove_column :cart_items, :prognosis
   remove_column :cart_items, :quantity
   remove_column :cart_items, :min_amount
   remove_column :cart_items, :max_amount
   remove_column :cart_items, :avail_amount
   remove_column :cart_items, :comment
   remove_column :cart_items, :user_price
   remove_column :cart_items, :actions
  end
end
=begin
Тип ("Склад", "ДМС", "Запрос", см. ниже)
Код номенклатуры - не отображаем пользователю :product_link
Наименование :product_name
Производитель :product_brend
ROHS :product_rohs
Цена :current_price
Количество :amount
Склад (для складских) :location_link
Прогноз (для ДМС, при выводе таблицы объединить с колонкой Склад) :prognosis
Минимальное количество предложения (для ДМС) - не отображаем пользователю :min_amount
Максимальное количество предложения (для ДМС) - не отображаем пользователю :max_amount
Доступное количество (для ДМС) - не отображаем пользователю :avail_amount
Кратность (для ДМС) - не отображаем пользователю :quantity
Примечание (Примечание для строки - тестовое поле ввода, заполняется пользователем) :comment
Цена клиента (числовое поле ввода, заполняется пользователем, только для строк с типом "Запрос") :user_price
Требование к позиции TODO
Действие ("Заказ", "Запрос", "Резерв", "Бронь", заполняется пользователем, см. ниже) :actions
=end
