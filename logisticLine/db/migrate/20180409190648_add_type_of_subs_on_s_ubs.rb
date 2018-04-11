class AddTypeOfSubsOnSUbs < ActiveRecord::Migration[5.0]
  def change
    add_column :alert_subscribes, :notification_type, :string
  end
end
