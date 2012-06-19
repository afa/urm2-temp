class AddKeyToArticle < ActiveRecord::Migration
  def change
   add_column :articles, :key, :string
  end
end
