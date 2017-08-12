class AddServiceNameToFulfillments < ActiveRecord::Migration
  def change
    add_column :fulfillments, :service_name, :string
  end
end
