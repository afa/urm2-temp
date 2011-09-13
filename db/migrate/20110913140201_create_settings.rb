class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.string :name
      t.string :value
      t.integer :settingable_id
      t.string :settingable_type

      t.timestamps
    end
    add_index :settings, [:settingable_id]
  end

  def self.down
    drop_table :settings
  end
end
