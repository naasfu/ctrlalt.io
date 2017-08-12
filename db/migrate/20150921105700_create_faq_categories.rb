class CreateFaqCategories < ActiveRecord::Migration
  def change
    create_table :faq_categories do |t|
      t.string :name, null: false
      t.string :slug, unique: true

      t.boolean :active, default: true, null: false
      t.boolean :visible, default: true, null: false

      t.integer :position
      
      t.timestamps null: false
    end
    add_index :faq_categories, :slug
  end
end
