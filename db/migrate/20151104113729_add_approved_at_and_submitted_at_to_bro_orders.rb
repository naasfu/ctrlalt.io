class AddApprovedAtAndSubmittedAtToBroOrders < ActiveRecord::Migration
  def change
    add_column :bro_orders, :submitted_at, :datetime
    add_column :bro_orders, :approved_at, :datetime
  end
end
