class CreateGroupBuyImages < ActiveRecord::Migration
  def change
    create_table :group_buy_images do |t|
      t.belongs_to :group_buy, index: true, foreign_key: true
      t.string :file
      t.string :caption
      t.integer :position

      t.timestamps null: false
    end
  end
end
