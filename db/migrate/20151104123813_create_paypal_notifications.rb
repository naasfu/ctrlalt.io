class CreatePaypalNotifications < ActiveRecord::Migration
  def change
    create_table :paypal_notifications do |t|
      t.belongs_to :bro_order, index: true, foreign_key: true
      t.text :params
      t.string :transaction_id
      t.string :status
    end
    add_index :paypal_notifications, :transaction_id
  end
end
