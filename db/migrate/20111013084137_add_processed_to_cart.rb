class AddProcessedToCart < ActiveRecord::Migration
  def self.up
   add_column :cart_items, :processed, :boolean, :default => false
  end

  def self.down
   remove_column :cart_items, :processed
  end
end
