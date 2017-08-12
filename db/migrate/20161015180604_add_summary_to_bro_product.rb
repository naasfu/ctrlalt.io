class AddSummaryToBroProduct < ActiveRecord::Migration
  def change
    add_column :bro_products, :summary, :text
  end
end
