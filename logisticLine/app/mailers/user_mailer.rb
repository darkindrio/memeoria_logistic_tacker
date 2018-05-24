class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def welcome_email
    @user = 'and31234@gmail.com'
    @url  = 'http://example.com/login'
    mail(to: @user, subject: 'Welcome to My Awesome Site')
  end
end
