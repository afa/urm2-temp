class AddFieldsToCart < ActiveRecord::Migration
  def self.up
   add_column :cart_items, :type, :string
  end

  def self.down
   remove_column :cart_items, :type
  end
end
