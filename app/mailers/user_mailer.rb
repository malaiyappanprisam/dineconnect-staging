class UserMailer < ActionMailer::Base
  default from: ENV['EMAIL_SENDER'] || 'no-reply@dineconnectapp.com'

  def registration_confirmation(user)
    @user = user

    mail(to: @user.email, subject: "Confirm your email to activate your account")
  end
end
