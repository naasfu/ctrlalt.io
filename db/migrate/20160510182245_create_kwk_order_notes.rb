class CreateKwkOrderNotes < ActiveRecord::Migration
  def change
    create_table :kwk_order_notes do |t|
      t.belongs_to :kwk_order, index: true, foreign_key: true
      t.belongs_to :user, index: true, foreign_key: true
      t.text :content

      t.timestamps null: false
    end
  end
end
