class AddBannerToBroProduct < ActiveRecord::Migration
  def change
    add_column :bro_products, :banner, :string
  end
end
