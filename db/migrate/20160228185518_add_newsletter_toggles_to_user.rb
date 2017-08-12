class AddNewsletterTogglesToUser < ActiveRecord::Migration
  def change
    add_column :users, :all_newsletters, :boolean, default: true
  end
end
