class AddBudgeaTokenToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :budgea_token, :string
  end
end
