class AddThumbnailToBroProduct < ActiveRecord::Migration
  def change
    add_column :bro_products, :thumbnail, :string
  end
end
