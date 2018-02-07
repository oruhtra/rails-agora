class AddActiveToServices < ActiveRecord::Migration[5.1]
  def change
    add_column :services, :active, :boolean, default: true
  end
end
