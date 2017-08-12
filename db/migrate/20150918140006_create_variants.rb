class CreateVariants < ActiveRecord::Migration
  def change
    create_table :variants do |t|
      t.belongs_to :product, index: true, foreign_key: true

      t.string  :name
      t.integer :stock
      t.integer :limit
      t.integer :weight

      t.integer :position

      t.decimal :unit_price, precision: 8, scale: 2
      t.decimal :cost_price, precision: 8, scale: 2
      t.decimal :sale_price, precision: 8, scale: 2

      t.boolean :active, default: true, null: false
      t.boolean :visible, default: true, null: false

      t.timestamps null: false
    end
  end
end
