class AddSourceToDocuments < ActiveRecord::Migration[5.1]
  def change
    add_column :documents, :source, :string
  end
end
