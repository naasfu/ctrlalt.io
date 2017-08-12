class AddApprovedAtToKwkOrders < ActiveRecord::Migration
  def change
    add_column :kwk_orders, :approved_at, :datetime
  end
end
