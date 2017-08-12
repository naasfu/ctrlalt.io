class CreateKwkLineItems < ActiveRecord::Migration
  def change
    create_table :kwk_line_items do |t|
      t.belongs_to :kwk_variant, index: true, foreign_key: true
      t.belongs_to :kwk_order, index: true, foreign_key: true

      t.decimal :unit_price, precision: 8, scale: 2

      t.string :kwk_sale_name
      t.string :product_name
      t.string :variant_name
      t.string :image_url
      t.string :color

      t.integer :position

      t.boolean :shipped, null: false, default: false
      t.boolean :approved, null: false, default: false

      t.timestamps null: false
    end

    add_index :kwk_line_items, :position
  end
end
