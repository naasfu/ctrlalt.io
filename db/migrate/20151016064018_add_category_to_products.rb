class AddCategoryToProducts < ActiveRecord::Migration
  def change
    add_reference :products, :product_category, index: true, foreign_key: true
  end
end
