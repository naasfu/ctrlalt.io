class CreateFaqs < ActiveRecord::Migration
  def change
    create_table :faqs do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :faq_category, index: true, foreign_key: true

      t.string :name
      t.string :caption
      t.string :content

      t.datetime :published_at

      t.string :meta_title
      t.string :slug, unique: true

      t.integer :position

      t.boolean :active, default: true, null: false
      t.boolean :visible, default: true, null: false

      t.timestamps null: false
    end
    add_index :faqs, :slug
    add_index :faqs, :position
  end
end
