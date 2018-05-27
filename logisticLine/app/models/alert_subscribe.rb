class AlertSubscribe < ApplicationRecord
  belongs_to :user
  belongs_to :container
  belongs_to :state

  def human_alert
    if notification_type == "danger"
      return "Peligro"
    elsif notification_type == "warning"
      return "Precaución"
    elsif notification_type == "normal"
      return "Normal"
    else
      return "No iniciada"
    end
  end

  def alert_class
    if notification_type == "danger"
      return "danger"
    elsif notification_type == "warning"
      return "warning"
    elsif notification_type == "normal"
      return "success"
    else
      return "default"
    end
  end

  #validates :notification_type, uniqueness: { scope: [:user_id, :container_id] }
end
