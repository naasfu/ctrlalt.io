class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.belongs_to :variant, index: true, foreign_key: true
      t.belongs_to :order, index: true, foreign_key: true

      t.integer :quantity, default: 1, null: false
      t.decimal :unit_price, precision: 8, scale: 2

      t.string :group_buy_name
      t.string :product_name
      t.string :variant_name

      t.boolean :shipped, null: false, default: false

      t.timestamps null: false
    end
  end
end
