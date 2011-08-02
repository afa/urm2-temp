class AddAxaptaParentIdToAccount < ActiveRecord::Migration
  def self.up
   add_column :accounts, :axapta_parent_id, :integer
  end

  def self.down
   remove_column :accounts, :axapta_parent_id
  end
end
