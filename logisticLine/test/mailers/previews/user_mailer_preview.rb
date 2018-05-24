# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def alert
    user = User.first
    alert = AlertSubscribe.last
    UserMailer.alert(user, alert)
  end
end
