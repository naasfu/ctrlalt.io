class CreateKwkSales < ActiveRecord::Migration
  def change
    create_table :kwk_sales do |t|
      t.string :name
      t.text :content
      t.text :caption
      t.string :banner
      t.string :logo

      t.datetime :deadline
      t.datetime :shipping_eta

      t.string :meta_title
      t.string :slug, unique: true

      t.boolean :active, default: true, null: false
      t.boolean :visible, default: true, null: false

      t.timestamps null: false
    end

    add_index :kwk_sales, :slug
  end
end
