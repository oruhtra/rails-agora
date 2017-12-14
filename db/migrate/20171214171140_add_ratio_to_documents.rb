class AddRatioToDocuments < ActiveRecord::Migration[5.1]
  def change
    add_column :documents, :ratio, :float
  end
end
