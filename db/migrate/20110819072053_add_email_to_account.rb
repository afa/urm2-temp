class AddEmailToAccount < ActiveRecord::Migration
  def self.up
   add_column :accounts, :contact_email, :string
  end

  def self.down
   remove_column :accounts, :contact_email
  end
end
