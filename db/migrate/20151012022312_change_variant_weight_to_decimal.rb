class ChangeVariantWeightToDecimal < ActiveRecord::Migration
  def up
    change_column :variants, :weight, :decimal, precision: 8, scale: 2
  end

  def down
    change_column :variants, :weight, :integer
  end
end
