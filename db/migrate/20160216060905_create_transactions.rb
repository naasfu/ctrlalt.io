class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|      
      t.string :guid
      t.belongs_to :order, index: true, foreign_key: true
      t.decimal :amount, precision: 8, scale: 2
      t.string :charge_id
      t.string :status
      t.string :full_name
      t.integer :last_4
      t.string :card_brand

      t.timestamps
    end
    add_index :transactions, :guid
  end
end
