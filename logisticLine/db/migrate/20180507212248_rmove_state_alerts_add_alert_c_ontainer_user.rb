class RmoveStateAlertsAddAlertCOntainerUser < ActiveRecord::Migration[5.0]
  def change
    remove_column :states, :alerts
    add_column :containers_users, :alerts, :string
  end
end
