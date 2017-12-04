class CreateDoctags < ActiveRecord::Migration[5.1]
  def change
    create_table :doctags do |t|
      t.references :document, foreign_key: true
      t.references :tag, foreign_key: true

      t.timestamps
    end
  end
end
