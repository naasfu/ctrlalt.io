class AddTruBroIdToBroLineItems < ActiveRecord::Migration
  def change
    add_column :bro_line_items, :tru_bro_id, :string
  end
end
