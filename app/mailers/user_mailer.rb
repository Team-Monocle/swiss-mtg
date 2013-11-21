class UserMailer < ActionMailer::Base
  default from: "noreply@tourn.io"

  def welcome_email(user)
    @user = user
    @url  = 'http://tourn-io.herokuapp.com/users/sign_in'
    mail(to: @user.email, subject: 'Welcome to Tourn.io!')
  end

end
