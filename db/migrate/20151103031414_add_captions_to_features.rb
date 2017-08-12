class AddCaptionsToFeatures < ActiveRecord::Migration
  def change
    add_column :group_buys, :caption, :text
    add_column :bro_sales, :caption, :text
  end
end
