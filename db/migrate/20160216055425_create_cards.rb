class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :fingerprint
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps
    end
  end
end
