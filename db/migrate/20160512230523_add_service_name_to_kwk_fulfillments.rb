class AddServiceNameToKwkFulfillments < ActiveRecord::Migration
  def change
    add_column :kwk_fulfillments, :service_name, :string
  end
end
