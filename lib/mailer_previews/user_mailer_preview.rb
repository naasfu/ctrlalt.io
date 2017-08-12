class UserMailerPreview < ActionMailer::Preview
  def email_confirmation_instructions
    UserMailer.email_confirmation_instructions(User.first)
  end

  def welcome
    UserMailer.welcome(User.first)
  end

  def password_reset_instructions
    user = User.first
    user.update_attributes(password_reset_token: SecureRandom.uuid(), password_reset_sent_at: Time.zone.now)
    UserMailer.password_reset_instructions(user)
  end
end