class InquiryMailerPreview < ActionMailer::Preview
  def received
    InquiryMailer.received(Inquiry.first)
  end
end