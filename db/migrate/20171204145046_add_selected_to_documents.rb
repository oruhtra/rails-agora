class AddSelectedToDocuments < ActiveRecord::Migration[5.1]
  def change
    add_column :documents, :selected, :boolean, default: false
  end
end
