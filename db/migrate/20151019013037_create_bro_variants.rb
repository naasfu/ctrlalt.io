class CreateBroVariants < ActiveRecord::Migration
  def change
    create_table :bro_variants do |t|
      t.belongs_to :bro_product, index: true, foreign_key: true

      t.string  :name
      
      t.integer :position

      t.decimal :weight, precision: 8, scale: 2

      t.decimal :unit_price, precision: 8, scale: 2

      t.boolean :active, default: true, null: false
      t.boolean :visible, default: true, null: false

      t.timestamps null: false
    end
  end
end
