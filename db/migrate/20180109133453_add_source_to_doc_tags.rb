class AddSourceToDocTags < ActiveRecord::Migration[5.1]
  def change
    add_column :doctags, :source, :string, default: "automatic"
  end
end
