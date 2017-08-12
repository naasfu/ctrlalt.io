class PingSlackInquiriesJob < ActiveJob::Base
  queue_as :slack

  def perform(inquiry, inquiry_link_url)
    PingSlack.inquiries(">>>*#{inquiry.subject}*\n_From #{inquiry.name} ([#{inquiry.email}](mailto:#{inquiry.email}?subject=#{inquiry.subject}&?body=#{inquiry.content}))_\n#{inquiry.content}\n[View inquiry](#{inquiry_link_url})")
  end
end
