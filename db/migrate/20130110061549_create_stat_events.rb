class CreateStatEvents < ActiveRecord::Migration
  def change
    create_table :stat_events do |t|
      t.string :key
      t.text :data
      t.string :type
      t.datetime :created_at
    end
  end
end
