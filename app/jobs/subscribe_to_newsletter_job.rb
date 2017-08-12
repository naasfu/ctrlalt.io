class SubscribeToNewsletterJob < ActiveJob::Base
  queue_as :default

  def perform(email)
    begin
      api_key = ENV['mailchimp_api_key']
      list_id = '1541fae722'

      gibbon = Gibbon::Request.new(api_key: api_key)
      
      gibbon.lists(list_id).members.create(
        body: { email_address: email, status: 'subscribed' }
      )
    rescue Gibbon::MailChimpError => e
      # MailChimp returns a 400 on create if the email already exists.
      # It will return a member object on create if we successfully subscribe
      # the user.
    end
  end
end
