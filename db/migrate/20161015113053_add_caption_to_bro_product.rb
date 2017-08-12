class AddCaptionToBroProduct < ActiveRecord::Migration
  def change
    add_column :bro_products, :caption, :text
  end
end
