class CreateBroFulfillments < ActiveRecord::Migration
  def change
    create_table :bro_fulfillments do |t|
      t.belongs_to :bro_order, index: true, foreign_key: true

      t.string :guid
      t.string :shipment_id
      t.string :tracking_number
      t.string :line_item_ids, array: true
      t.string :workflow_state
      
      t.text :notes
      
      t.datetime :shipped_at
      t.datetime :delivered_at

      t.timestamps null: false
    end
    add_index :bro_fulfillments, :guid
  end
end
