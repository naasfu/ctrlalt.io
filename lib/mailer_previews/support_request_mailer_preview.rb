class SupportRequestMailerPreview < ActionMailer::Preview
  def opened
    SupportRequestMailer.opened(SupportRequest.with_open_state.first)
  end

  def new_reply
    SupportRequestMailer.new_reply(SupportRequest.with_open_state.first)
  end
end