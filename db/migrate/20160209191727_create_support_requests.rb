class CreateSupportRequests < ActiveRecord::Migration
  def change
    create_table :support_requests do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :order, index: true, foreign_key: true
      t.string :subject
      t.string :guid
      t.text :content
      t.string :workflow_state
      t.datetime :resolved_at
      t.datetime :closed_at
      t.text :tags, array: true, default: []

      t.timestamps null: false
    end
    add_index :support_requests, :guid
    add_index :support_requests, :tags, using: 'gin'
  end
end
