class AddDefaultValuePrototypeToDocuments < ActiveRecord::Migration[5.1]
  def change
    remove_column :documents, :prototype
    add_column :documents, :prototype, :boolean, default: false
  end
end
