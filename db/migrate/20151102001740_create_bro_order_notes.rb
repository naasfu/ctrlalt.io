class CreateBroOrderNotes < ActiveRecord::Migration
  def change
    create_table :bro_order_notes do |t|
      t.belongs_to :bro_order, index: true, foreign_key: true
      t.belongs_to :user, index: true, foreign_key: true
      t.text :content

      t.timestamps null: false
    end
  end
end
