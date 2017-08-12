class AddDetailsToFulfillments < ActiveRecord::Migration
  def change
    add_column :fulfillments, :weight, :decimal, precision: 8, scale: 2
    add_column :fulfillments, :cost, :decimal, precision: 8, scale: 2
      
    add_column :fulfillments, :rate_id, :string
    add_column :fulfillments, :shipment_service, :string
  end
end
