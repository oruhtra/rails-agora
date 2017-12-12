class AddBudgeaDocIdToDocuments < ActiveRecord::Migration[5.1]
  def change
    add_column :documents, :budgea_doc_id, :integer
  end
end
