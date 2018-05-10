class AddAlertsToContainersUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :states, :alerts, :string
  end
end
