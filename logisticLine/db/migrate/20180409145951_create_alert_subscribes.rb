class CreateAlertSubscribes < ActiveRecord::Migration[5.0]
  def change
    create_table :alert_subscribes do |t|
      t.belongs_to :user, index: true
      t.belongs_to :container, index: true
      t.timestamps
    end
  end
end
