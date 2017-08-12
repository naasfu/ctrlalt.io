class CreateInquiries < ActiveRecord::Migration
  def change
    create_table :inquiries do |t|
      t.belongs_to :user, index: true, foreign_key: true

      t.string :guid

      t.string :subject
      t.string :name
      t.string :email
      t.text   :content

      t.timestamps null: false
    end
    
    add_index :inquiries, :guid
  end
end
