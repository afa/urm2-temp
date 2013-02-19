class AddSalesOriginToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :sales_origin, :string
  end
end
