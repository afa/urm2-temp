class CreateManagers < ActiveRecord::Migration
  def self.up
    create_table :managers do |t|
      t.string :name
      t.string :salt
      t.string :encrypted_password
      t.boolean :super
      t.timestamps
    end
  end

  def self.down
    drop_table :managers
  end
end
