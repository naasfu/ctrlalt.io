class AddShipmentIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :shipment_id, :string
  end
end
