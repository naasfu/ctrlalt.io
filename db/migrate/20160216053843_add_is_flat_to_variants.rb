class AddIsFlatToVariants < ActiveRecord::Migration
  def change
    add_column :variants, :is_flat, :boolean, default: false
  end
end
