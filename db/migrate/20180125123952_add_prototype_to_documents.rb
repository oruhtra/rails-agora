class AddPrototypeToDocuments < ActiveRecord::Migration[5.1]
  def change
    add_column :documents, :prototype, :boolean
  end
end
