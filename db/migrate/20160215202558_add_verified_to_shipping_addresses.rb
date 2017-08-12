class AddVerifiedToShippingAddresses < ActiveRecord::Migration
  def change
    add_column :shipping_addresses, :verified, :boolean, null: false, default: true
  end
end
