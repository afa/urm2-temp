class CurrencyPresenter
 include ActionView::Helpers::NumberHelper
 CURRENCY_RULES = {
  :usd => { :separator => ',', :delimiter => ' ', :precision => 4, :unit => ''},
  :rub => { :separator => ',', :delimiter => ' ', :precision => 2, :unit => ''},
  :uah => { :separator => ',', :delimiter => ' ', :precision => 2, :unit => ''},
  :csv => { :separator => ',', :delimiter => '', :precision => 4, :unit => ''}
 }
 def initialize(curr)
  @currency = curr
 end

 def decore(num)
  #val = num.is_a?(Float) ? num : num.to_f
  number_to_currency(num, CURRENCY_RULES[@currency].merge(:raise => true)) rescue nil
 end
end
