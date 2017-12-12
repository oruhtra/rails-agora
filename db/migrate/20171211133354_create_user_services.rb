class CreateUserServices < ActiveRecord::Migration[5.1]
  def change
    create_table :user_services do |t|
      t.references :user, foreign_key: true
      t.references :service, foreign_key: true
      t.integer :connection_id

      t.timestamps
    end
  end
end
