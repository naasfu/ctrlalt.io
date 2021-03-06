class CreateBroOrders < ActiveRecord::Migration
  def change
    create_table :bro_orders do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :shipping_address, index: true, foreign_key: true

      t.string :email

      t.string :guid
      t.string :session_id
      t.string :workflow_state
      t.string :geekhack_username

      t.string :shipment_id
      t.string :tracking_number

      t.string :ip_address
      
      t.string :transaction_id
      t.string :paypal_email

      t.text :user_notes

      t.datetime :paid_at
      t.datetime :placed_at

      t.decimal :donation_amount,   precision: 8, scale: 2, default: 3.00
      t.decimal :shipping_amount,   precision: 8, scale: 2
      t.decimal :line_items_amount, precision: 8, scale: 2
      t.decimal :fee_amount,        precision: 8, scale: 2

      t.timestamps null: false
    end

    add_index :bro_orders, :guid
  end
end
