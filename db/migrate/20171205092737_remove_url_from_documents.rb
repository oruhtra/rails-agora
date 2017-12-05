class RemoveUrlFromDocuments < ActiveRecord::Migration[5.1]
  def change
    remove_column :documents, :url
  end
end
