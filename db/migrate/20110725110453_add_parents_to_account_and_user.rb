class AddParentsToAccountAndUser < ActiveRecord::Migration
  def self.up
   add_column :users, :parent_id, :integer
   add_column :accounts, :parent_id, :integer
   add_index :accounts, [:parent_id]
   add_index :users, [:parent_id]
  end

  def self.down
   remove_column :accounts, :parent_id
   remove_column :users, :parent_id
  end
end
