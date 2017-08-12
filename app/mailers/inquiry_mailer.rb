class InquiryMailer < ApplicationMailer
  def received(inquiry)
    @inquiry = inquiry
    mail(to: @inquiry.email, subject: "Thanks for contacting us, your message has been received!")
  end
end