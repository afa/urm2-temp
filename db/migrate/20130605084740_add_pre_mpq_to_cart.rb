class AddPreMpqToCart < ActiveRecord::Migration
  def change
   add_column :cart_items, :pre_mpq, :integer
   add_column :cart_items, :mpq_msg, :string
  end
end
