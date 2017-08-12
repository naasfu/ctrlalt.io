class UserMailer < ApplicationMailer
  def welcome(user)
    @user = user
    mail(to: @user.email, subject: "Welcome to [CTRL]ALT")
  end

  def email_confirmation_instructions(user)
    @user = user
    mail(to: @user.email, subject: "Please confirm your email address for [CTRL]ALT")
  end

  def password_reset_instructions(user)
    @user = user
    mail(to: @user.email, subject: 'Password reset instructions')
  end
end