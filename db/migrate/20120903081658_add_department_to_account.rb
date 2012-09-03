class AddDepartmentToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :department, :string
  end
end
