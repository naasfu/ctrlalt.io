class RenameFaqQAndA < ActiveRecord::Migration
  def change
    rename_column :faqs, :name,    :q
    rename_column :faqs, :content, :a
  end
end
