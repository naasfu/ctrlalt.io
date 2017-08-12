class AddColorToBroLineItems < ActiveRecord::Migration
  def change
    add_column :bro_line_items, :color, :string
  end
end
