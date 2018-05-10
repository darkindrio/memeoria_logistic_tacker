class AddMessageToAlertsSubs < ActiveRecord::Migration[5.0]
  def change
    add_column :alert_subscribes, :message, :string
  end
end
