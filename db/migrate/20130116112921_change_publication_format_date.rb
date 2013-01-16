class ChangePublicationFormatDate < ActiveRecord::Migration
  def up
    change_table :news_articles do |t|
      t.change :publication_start, :date
    end
  end

  def down
    change_table :news_articles do |t|
      t.change :publication_start, :datetime
    end
  end
end
