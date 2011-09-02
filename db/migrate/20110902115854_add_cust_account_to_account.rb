class AddCustAccountToAccount < ActiveRecord::Migration
  def self.up
   add_column :accounts, :cust_account, :string
  end

  def self.down
   remove_column :accounts, :cust_account
  end
end
