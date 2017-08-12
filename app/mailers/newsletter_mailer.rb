class NewsletterMailer < ApplicationMailer

  layout 'newsletter_mailer'

  default from: '[CTRL]ALT Newsletter <newsletter@ctrlalt.io>'
  
  def generic(user, newsletter)
    @user = user
    @newsletter = newsletter
    @group_buy  = newsletter.group_buy
    mail(to: @user.email, subject: @newsletter.subject)
  end
end