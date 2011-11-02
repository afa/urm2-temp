class AddDraftToCartItem < ActiveRecord::Migration
  def self.up
    add_column :cart_items, :draft, :boolean, :null => false, :default => true
  end

  def self.down
    remove_column :cart_items, :draft
  end
end
