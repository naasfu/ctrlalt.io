class CreateKwkOrders < ActiveRecord::Migration
  def change
    create_table :kwk_orders do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :shipping_address, index: true

      t.string :email

      t.string :guid
      t.string :session_id
      t.string :workflow_state
      t.string :geekhack_username

      t.string :ip_address
      
      t.string :transaction_id
      t.string :paypal_email

      t.text :user_notes

      t.integer :kap_count, default: 2

      t.datetime :paid_at
      t.datetime :submitted_at

      t.decimal :donation_amount,   precision: 8, scale: 2, default: 3.00
      t.decimal :shipping_amount,   precision: 8, scale: 2
      t.decimal :line_items_amount, precision: 8, scale: 2
      t.decimal :fee_amount,        precision: 8, scale: 2

      t.timestamps null: false
    end

    add_index :kwk_orders, :guid

    add_foreign_key :kwk_orders, :addresses, column: :shipping_address_id
  end
end
