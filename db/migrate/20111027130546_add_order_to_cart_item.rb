class AddOrderToCartItem < ActiveRecord::Migration
  def self.up
    add_column :cart_items, :order_id, :integer
    add_index :cart_items, [:order_id]
  end

  def self.down
    remove_column :cart_items, :order_id
  end
end
