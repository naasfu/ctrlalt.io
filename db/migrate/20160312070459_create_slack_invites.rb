class CreateSlackInvites < ActiveRecord::Migration
  def change
    create_table :slack_invites do |t|
      t.string :email
      t.boolean :invited, default: false

      t.timestamps null: false
    end
  end
end
