class SendNewsletterJob < ActiveJob::Base
  queue_as :newsletters

  def perform(newsletter)
    recipients = newsletter.recipients

    if recipients.any?
      recipients.each do |user|
        NewsletterMailer.generic(user, newsletter).deliver_later
      end
    end
  end
end
