class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.datetime :published_at
      t.text :content
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :group_buy, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
