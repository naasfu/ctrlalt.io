class CreateShippingAddresses < ActiveRecord::Migration
  def change
    create_table :shipping_addresses do |t|
      t.string :full_name, null: false
      t.string :street1,   null: false
      t.string :street2
      t.string :city,      null: false
      t.string :state,     null: false
      t.string :zip,       null: false
      t.string :country,   null: false, default: 'US'
      t.string :phone

      t.timestamps null: false
    end
  end
end
