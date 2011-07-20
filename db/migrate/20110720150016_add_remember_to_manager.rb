class AddRememberToManager < ActiveRecord::Migration
  def self.up
   add_column :managers, :remember_token, :string
   add_index :managers, [:remember_token]
  end

  def self.down
   remove_column :managers, :remember_token
  end
end
