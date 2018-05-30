# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def alert
    user = User.first
    alert = AlertSubscribe.last
    UserMailer.alert(user, alert)
  end

  def change_state
    user = User.first
    state = State.last
    UserMailer.change_state(user, state)
  end
end
