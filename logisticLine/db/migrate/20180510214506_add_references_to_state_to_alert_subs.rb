class AddReferencesToStateToAlertSubs < ActiveRecord::Migration[5.0]
  def change
    add_reference :alert_subscribes, :states, index: true
  end
end
