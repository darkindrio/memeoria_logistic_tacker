class RenameStateIdForAlertSubs < ActiveRecord::Migration[5.0]
  def change
    rename_column :alert_subscribes, :states_id, :state_id
  end
end
