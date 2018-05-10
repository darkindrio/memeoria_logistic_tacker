class AlertSubscribe < ApplicationRecord
  belongs_to :user
  belongs_to :container
  belongs_to :state

  #validates :notification_type, uniqueness: { scope: [:user_id, :container_id] }
end
