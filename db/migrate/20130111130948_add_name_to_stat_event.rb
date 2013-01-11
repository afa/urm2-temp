class AddNameToStatEvent < ActiveRecord::Migration
  def change
   add_column :stat_events, :name, :string
  end
end
