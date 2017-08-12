class NewsletterMailerPreview < ActionMailer::Preview
  def generic
    user = User.first
    newsletter = Newsletter.first
    NewsletterMailer.generic(user, newsletter)
  end
end