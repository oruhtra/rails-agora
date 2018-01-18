class ChangeColumnBudgeaDocIdFromDocuments < ActiveRecord::Migration[5.1]
  def change
    remove_column :documents, :budgea_doc_id
    add_column :documents, :budgea_doc_id, :date
    remove_column :services, :budgea_name
  end
end
