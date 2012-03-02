class AddRequirementsToCartItem < ActiveRecord::Migration
  def change
    add_column :cart_items, :requirements, :text
  end
end
