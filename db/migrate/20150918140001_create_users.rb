class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string   :username, unique: true, null: false
      t.string   :geekhack_username, unique: true
      t.string   :email, null: false, unique: true

      t.string   :stripe_customer_id

      t.string   :password_digest, null: false

      t.string   :confirmation_token
      t.boolean  :confirmed, default: false, null: false

      t.string   :password_reset_token
      t.datetime :password_reset_sent_at

      t.boolean :admin, default: false, null: false

      t.timestamps null: false
    end

    add_index :users, :email
  end
end
