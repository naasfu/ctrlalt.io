class UpdateOrderReferences < ActiveRecord::Migration
  def change
    remove_foreign_key :orders, :shipping_addresses

    add_reference :orders, :billing_address, index: true

    add_foreign_key :orders, :addresses, column: :billing_address_id
  end
end
