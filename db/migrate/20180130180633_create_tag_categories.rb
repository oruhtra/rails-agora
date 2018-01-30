class CreateTagCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :tag_categories do |t|
      t.references :tag, index: true, foreign_key: true
      t.references :macro_category, index: true

      t.timestamps
    end

    add_foreign_key :tag_categories, :tags, column: :macro_category_id
    add_index :tag_categories, [:tag_id, :macro_category_id], unique: true
  end
end
