class AddBudgeaIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :budgea_id, :integer
  end
end
