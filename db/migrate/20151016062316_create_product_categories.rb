class CreateProductCategories < ActiveRecord::Migration
  def change
    create_table :product_categories do |t|
      t.string :name, null: false
      t.string :slug, unique: true

      t.boolean :active, default: true, null: false
      t.boolean :visible, default: true, null: false

      t.integer :position
      
      t.timestamps null: false
    end
    
    add_index :product_categories, :slug
  end
end
