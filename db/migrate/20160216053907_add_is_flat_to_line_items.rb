class AddIsFlatToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :is_flat, :boolean, default: false
  end
end
