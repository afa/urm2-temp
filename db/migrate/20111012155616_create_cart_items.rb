class CreateCartItems < ActiveRecord::Migration
  def self.up
    create_table :cart_items do |t|
      t.integer :user_id
      t.integer :amount
      t.string :product_link
      t.string :location_link
      t.string :product_name
      t.string :product_rohs
      t.string :product_brend
      t.timestamps
    end
  end

  def self.down
    drop_table :cart_items
  end
end
