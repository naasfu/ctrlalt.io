class CreateProductImages < ActiveRecord::Migration
  def change
    create_table :product_images do |t|
      t.belongs_to :product, index: true, foreign_key: true
      t.string :file
      t.string :caption
      t.integer :position

      t.timestamps null: false
    end
  end
end
