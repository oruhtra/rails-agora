class ChangeBudgeaDocIdFromDocumentsToString < ActiveRecord::Migration[5.1]
  def change
    remove_column :documents, :budgea_doc_id
    add_column :documents, :budgea_doc_id, :string
  end
end
