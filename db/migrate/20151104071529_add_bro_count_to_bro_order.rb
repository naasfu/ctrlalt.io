class AddBroCountToBroOrder < ActiveRecord::Migration
  def change
    add_column :bro_orders, :bro_count, :integer, default: 2
  end
end
