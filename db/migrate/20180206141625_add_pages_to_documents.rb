class AddPagesToDocuments < ActiveRecord::Migration[5.1]
  def change
    add_column :documents, :pages, :integer
  end
end
