class UpdateFaqAColumnType < ActiveRecord::Migration
  def change
    change_column :faqs, :a, :text
  end
end
