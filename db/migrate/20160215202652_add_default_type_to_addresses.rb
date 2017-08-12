class AddDefaultTypeToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :type, :string, default: "ShippingAddress"
  end
end
