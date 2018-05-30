class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def welcome_email
    @user = 'and31234@gmail.com'
    @url  = 'http://example.com/login'
    mail(to: @user, subject: 'Welcome to My Awesome Site')
  end

  def alert(user, alert)
    @user = user
    @alert =alert
    mail(to:@user.email, subject: 'Alerta')
  end

  def change_state(user, state)
    @user = user
    @state = state
    mail(to:'and31234@gmail.com', subject: 'Cambio de estado')
  end

end
