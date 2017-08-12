class CreateBroLineItems < ActiveRecord::Migration
  def change
    create_table :bro_line_items do |t|
      t.belongs_to :bro_variant, index: true, foreign_key: true
      t.belongs_to :bro_order, index: true, foreign_key: true

      t.integer :position
      t.decimal :unit_price, precision: 8, scale: 2

      t.string :bro_sale_name
      t.string :product_name
      t.string :variant_name

      t.boolean :approved, null: false, default: false
      t.boolean :shipped, null: false, default: false

      t.timestamps null: false
    end
    add_index :bro_line_items, :position
  end
end
