class CreateCarousels < ActiveRecord::Migration
  def change
    create_table :carousels do |t|
      t.string :title
      t.text :caption
      t.integer :position
      t.string :file
      t.string :url

      t.timestamps
    end
    add_index :carousels, :position
  end
end
