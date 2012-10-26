class AddEmplPhoneToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :string, :empl_phone
  end
end
