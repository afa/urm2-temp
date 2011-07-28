class AddFieldsToAccount < ActiveRecord::Migration
  def self.up
   add_column :accounts, :blocked, :boolean, :default => false
   add_column :accounts, :empl_name, :string
   add_column :accounts, :empl_email, :string
   %w(first middle last).each {|n| add_column :accounts, :"contact_#{n}_name", :string}
   add_column :accounts, :business, :string
  end

  def self.down
   remove_column :accounts, :blocked
   remove_column :accounts, :empl_name
   remove_column :accounts, :empl_email
   %w(first middle last).each {|n| remove_column :accounts, :"contact_#{n}_name"}
   remove_column :accounts, :business
  end
end
