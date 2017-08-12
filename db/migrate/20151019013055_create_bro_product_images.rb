class CreateBroProductImages < ActiveRecord::Migration
  def change
    create_table :bro_product_images do |t|
      t.belongs_to :bro_product, index: true, foreign_key: true
      t.string :file
      t.string :caption
      t.integer :position

      t.timestamps null: false
    end
  end
end
