class AddApplicationAreaMandatoryToCarts < ActiveRecord::Migration
  def change
    add_column :cart_items, :application_area_mandatory, :boolean
  end
end
