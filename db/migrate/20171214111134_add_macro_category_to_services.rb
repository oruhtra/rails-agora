class AddMacroCategoryToServices < ActiveRecord::Migration[5.1]
  def change
    add_column :services, :macro_category, :string
  end
end
