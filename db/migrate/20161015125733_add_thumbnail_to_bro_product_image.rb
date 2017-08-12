class AddThumbnailToBroProductImage < ActiveRecord::Migration
  def change
    add_column :bro_product_images, :thumbnail, :string
  end
end
