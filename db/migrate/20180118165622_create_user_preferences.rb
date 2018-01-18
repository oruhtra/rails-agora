class CreateUserPreferences < ActiveRecord::Migration[5.1]
  def change
    create_table :user_preferences do |t|
      t.string :setting
      t.boolean :value
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
