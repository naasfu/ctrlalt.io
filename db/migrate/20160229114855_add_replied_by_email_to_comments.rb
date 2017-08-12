class AddRepliedByEmailToComments < ActiveRecord::Migration
  def change
    add_column :comments, :replied_by_email, :boolean, default: false
  end
end
