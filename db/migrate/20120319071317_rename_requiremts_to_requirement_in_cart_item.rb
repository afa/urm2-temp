class RenameRequiremtsToRequirementInCartItem < ActiveRecord::Migration
  def change
   add_column :cart_items, :requirement, :text
   remove_column :cart_items, :requirements
  end
end
