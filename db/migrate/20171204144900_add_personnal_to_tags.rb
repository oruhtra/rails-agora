class AddPersonnalToTags < ActiveRecord::Migration[5.1]
  def change
    add_column :tags, :personnal, :boolean, default: null
  end
end
