class AddPrimaryColorToBroProduct < ActiveRecord::Migration
  def change
    add_column :bro_products, :primary_color, :string
  end
end
