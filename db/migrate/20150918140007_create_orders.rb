class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :shipping_address, index: true, foreign_key: true

      t.string :email

      t.string :guid
      t.string :session_id
      t.string :workflow_state
      t.string :geekhack_username

      t.string :shipment_service

      t.string :ip_address
      
      t.string :charge_id

      t.string :tracking_number
      t.string :paypal_email

      t.text :user_notes
      t.text :tracking_notes
      t.text :admin_notes

      t.text :legacy_shipping_address

      t.datetime :paid_at
      t.datetime :placed_at

      t.decimal :donation_amount,   precision: 8, scale: 2, default: 3.00
      t.decimal :shipping_amount,   precision: 8, scale: 2
      t.decimal :line_items_amount, precision: 8, scale: 2
      t.decimal :fee_amount,        precision: 8, scale: 2

      t.timestamps null: false
    end

    add_index :orders, :guid
    add_index :orders, :charge_id
  end
end
