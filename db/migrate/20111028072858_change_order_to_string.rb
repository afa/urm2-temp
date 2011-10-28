class ChangeOrderToString < ActiveRecord::Migration
  def self.up
   add_column :cart_items, :order, :string
   remove_column :cart_items, :order_id
  end

  def self.down
   add_column :cart_items, :order_id, :integer
   remove_column :cart_items, :order
  end
end
