class CreateTrackingNotes < ActiveRecord::Migration
  def change
    create_table :tracking_notes do |t|
      t.belongs_to :order, index: true, foreign_key: true
      t.string :tracking_number
      t.text :notes

      t.timestamps null: false
    end
  end
end
