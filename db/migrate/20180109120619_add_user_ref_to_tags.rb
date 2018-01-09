class AddUserRefToTags < ActiveRecord::Migration[5.1]
  def change
    add_reference :tags, :user, foreign_key: true
  end
end
