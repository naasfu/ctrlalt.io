class RenameShippingAddressesToAddresses < ActiveRecord::Migration
  def change
    rename_table :shipping_addresses, :addresses
  end
end
