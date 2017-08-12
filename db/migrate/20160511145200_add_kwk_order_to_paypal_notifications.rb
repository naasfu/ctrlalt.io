class AddKwkOrderToPaypalNotifications < ActiveRecord::Migration
  def change
    add_reference :paypal_notifications, :kwk_order, index: true, foreign_key: true
  end
end
