class AddRateIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :rate_id, :string
  end
end
