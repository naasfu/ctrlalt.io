class SupportRequestMailer < ApplicationMailer
  layout 'support_request_mailer'

  def opened(support_request)
    @support_request = support_request
    @user = @support_request.user
    mail to: @user.email, from: "[CTRL]ALT Support <request+#{@support_request.guid}@feedback-ctrlalt.io>", subject: @support_request.subject
  end

  def resolved(support_request)
  end

  def new_reply(support_request)
    @support_request = support_request
    @comments = @support_request.comments.newest
    @user = @support_request.user
    mail to: @user.email, from: "[CTRL]ALT Support <request+#{@support_request.guid}@feedback-ctrlalt.io>", subject: "Re: #{@support_request.subject}"
  end
end
