class ChgValueLength < ActiveRecord::Migration
  def up
   change_column :settings, :value, :string, {:limit => 8192}
  end

  def down
   change_column :settings, :value, :string, {:limit => 256}
  end
end
