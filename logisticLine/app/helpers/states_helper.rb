module StatesHelper

  def send_email(container_id)
    subscribers = ContainersUser.where(container_id: container_id)
    subscribers.each do |subscriber|
      if /state/.match(subscriber.alerts)
        user = User.find(subscriber.user_id)
        puts "enviar correo"
        puts user.email
      end
    end
  end

  def send_alert_email(container_id,state_id)
    subscribers = ContainersUser.where(container_id: container_id)
    subscribers.each do |subscriber|
      if /alert/.match(subscriber.alerts)
        user = User.find(subscriber.user_id)
        state = State.find(state_id)
        UserMailer.alert(user, state)
      end
    end
  end
end
