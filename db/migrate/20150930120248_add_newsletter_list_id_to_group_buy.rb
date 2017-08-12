class AddNewsletterListIdToGroupBuy < ActiveRecord::Migration
  def change
    add_column :group_buys, :newsletter_list_id, :string
  end
end
