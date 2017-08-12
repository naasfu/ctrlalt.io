class AddLatLongToShippingAddresses < ActiveRecord::Migration
  def change
    add_column :shipping_addresses, :latitude, :string
    add_column :shipping_addresses, :longitude, :string
  end
end
