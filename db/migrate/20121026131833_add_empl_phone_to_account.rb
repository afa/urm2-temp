class AddEmplPhoneToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :empl_phone, :string
  end
end
