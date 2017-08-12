class CreateBroSales < ActiveRecord::Migration
  def change
    create_table :bro_sales do |t|
      t.string :name
      t.text :content
      t.string :banner
      t.string :logo

      t.string :newsletter_list_id

      t.datetime :deadline
      t.datetime :shipping_eta

      t.string :meta_title
      t.string :slug, unique: true

      t.boolean :active, default: true, null: false
      t.boolean :visible, default: true, null: false

      t.timestamps null: false
    end

    add_index :bro_sales, :slug
  end
end
