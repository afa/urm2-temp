class AddReserveAndPickToCartItems < ActiveRecord::Migration
  def self.up
    add_column :cart_items, :reserve, :boolean, :default => false
    add_column :cart_items, :pick, :boolean, :default => false
  end

  def self.down
    remove_column :cart_items, :pick
    remove_column :cart_items, :reserve
  end
end
