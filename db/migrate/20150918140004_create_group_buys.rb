class CreateGroupBuys < ActiveRecord::Migration
  def change
    create_table :group_buys do |t|
      t.belongs_to :user, index: true, foreign_key: true

      t.string :name
      t.text :content
      t.string :image

      t.datetime :deadline
      t.datetime :shipping_eta

      t.string :meta_title
      t.string :slug, unique: true

      t.boolean :active, default: true, null: false
      t.boolean :visible, default: true, null: false

      t.timestamps null: false
    end

    add_index :group_buys, :slug
  end
end
