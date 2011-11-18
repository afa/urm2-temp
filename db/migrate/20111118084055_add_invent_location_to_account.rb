class AddInventLocationToAccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :invent_location_id, :string
  end

  def self.down
    remove_column :accounts, :invent_location_id
  end
end
