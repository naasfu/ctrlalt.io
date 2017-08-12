class CreateSnippets < ActiveRecord::Migration
  def change
    create_table :snippets do |t|
      t.string :name
      t.string :scope
      t.text :content

      t.timestamps
    end
    add_index :snippets, :name
    add_index :snippets, :scope
  end
end
