module UsersHelper

  def subscribe(alert_type, container)
    if !current_user.has_alert?(alert_type, container)
      subscribe = AlertSubscribe.new
      subscribe.user = current_user
      subscribe.container_id = params['container_id']
      subscribe.notification_type = alert_type
      subscribe.save
    end
  end
end
