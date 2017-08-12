class DropDefaultTypeOnAddresses < ActiveRecord::Migration
  def change
    change_column_default :addresses, :type, default: ""
  end
end
