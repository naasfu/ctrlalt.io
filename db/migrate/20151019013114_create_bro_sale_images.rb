class CreateBroSaleImages < ActiveRecord::Migration
  def change
    create_table :bro_sale_images do |t|
      t.belongs_to :bro_sale, index: true, foreign_key: true
      t.string :file
      t.string :caption
      t.integer :position

      t.timestamps null: false
    end
  end
end
