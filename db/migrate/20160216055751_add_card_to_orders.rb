class AddCardToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :card, index: true, foreign_key: true
  end
end
