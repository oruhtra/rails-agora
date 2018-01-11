class AddBudgeaNameToServices < ActiveRecord::Migration[5.1]
  def change
    add_column :services, :budgea_name, :string
  end
end
