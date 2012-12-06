class AddAuthorToNewsArticle < ActiveRecord::Migration
  def change
   add_column :news_articles, :last_editor_id, :integer
   add_column :news_articles, :publication_start, :datetime
   add_column :news_articles, :publication_end, :datetime
  end
end
