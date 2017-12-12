class CreateServices < ActiveRecord::Migration[5.1]
  def change
    create_table :services do |t|
      t.string :name
      t.string :url
      t.string :logo
      t.integer :budgea_id

      t.timestamps
    end
  end
end
