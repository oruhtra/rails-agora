class AddMacroCategoryToTags < ActiveRecord::Migration[5.1]
  def change
    add_column :tags, :macro_category, :string, default: nil
  end
end
