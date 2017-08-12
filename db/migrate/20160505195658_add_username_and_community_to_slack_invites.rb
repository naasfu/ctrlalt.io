class AddUsernameAndCommunityToSlackInvites < ActiveRecord::Migration
  def change
    add_column :slack_invites, :username, :string, null: false
    add_column :slack_invites, :on_reddit, :boolean, default: true, null: false
    add_column :slack_invites, :on_geekhack, :boolean, default: true, null: false
  end
end
