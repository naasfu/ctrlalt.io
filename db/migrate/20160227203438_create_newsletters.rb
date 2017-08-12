class CreateNewsletters < ActiveRecord::Migration
  def change
    create_table :newsletters do |t|
      t.text :content
      t.string :subject
      t.string :slug, unique: true
      t.datetime :last_sent_at
      t.belongs_to :group_buy, index: true, foreign_key: true
      t.timestamps null: false
    end
    
    add_index :newsletters, :slug
  end
end
