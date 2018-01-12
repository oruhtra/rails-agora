class RemoveColumnPersonnalFromTags < ActiveRecord::Migration[5.1]
  def change
    remove_column :tags, :personnal
  end
end
