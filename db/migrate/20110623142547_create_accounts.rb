class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
     t.string :axapta_hash, :null=>false
     t.string :name
     t.integer :user_id
     t.timestamps
    end
    add_index :accounts, [:user_id]
  end

  def self.down
    drop_table :accounts
  end
end
