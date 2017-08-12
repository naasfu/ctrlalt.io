class AddOnHoldAtToSupportRequests < ActiveRecord::Migration
  def change
    add_column :support_requests, :on_hold_at, :datetime
  end
end
