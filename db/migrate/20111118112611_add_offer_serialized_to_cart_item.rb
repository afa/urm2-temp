class AddOfferSerializedToCartItem < ActiveRecord::Migration
  def self.up
    add_column :cart_items, :offer_serialized, :text
  end

  def self.down
    remove_column :cart_items, :offer_serialized
  end
end
