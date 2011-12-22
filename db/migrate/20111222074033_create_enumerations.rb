class CreateEnumerations < ActiveRecord::Migration
  def self.up
    create_table :enumerations do |t|
      t.string :name, :null => false
      t.text :values
      t.timestamps
    end
  end

  def self.down
    drop_table :enumerations
  end
end
