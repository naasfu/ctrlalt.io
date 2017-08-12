class CreateKwkProducts < ActiveRecord::Migration
  def change
    create_table :kwk_products do |t|
      t.belongs_to :kwk_sale, index: true, foreign_key: true

      t.string :name
      t.text :content
      
      t.string :image
      t.string :thumbnail

      t.integer :position

      t.string :meta_title
      t.string :slug, unique: true

      t.boolean :active, default: true, null: false
      t.boolean :visible, default: true, null: false

      t.timestamps null: false
    end
  end
end
