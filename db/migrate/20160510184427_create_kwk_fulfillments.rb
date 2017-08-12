class CreateKwkFulfillments < ActiveRecord::Migration
  def change
    create_table :kwk_fulfillments do |t|
      t.belongs_to :kwk_order, index: true, foreign_key: true

      t.string :guid
      t.string :tracking_number
      t.string :line_item_ids, array: true
      t.string :workflow_state
      
      t.text :notes
      t.text :customer_notes
      
      t.datetime :shipped_at
      t.datetime :delivered_at

      t.timestamps null: false
    end
    add_index :kwk_fulfillments, :guid
  end
end
