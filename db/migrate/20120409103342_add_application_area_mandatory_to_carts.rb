class AddApplicationAreaMandatoryToCarts < ActiveRecord::Migration
  def change
    add_column :cart_items, :application_area_mandatory, :boolean
    #add_column :cart_items, :application_area_id, :string
  end
end
