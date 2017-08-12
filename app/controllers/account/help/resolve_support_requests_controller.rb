class Account::Help::ResolveSupportRequestsController < Account::AccountsController
  before_action :set_support_request

  def resolve
    if @support_request.open?
      @support_request.resolve!
      redirect_to account_help_support_request_url(@support_request), success: "This support request has been resolved."
    elsif @support_request.resolved?
      redirect_to account_help_support_request_url(@support_request), success: "This support request has already been resolved."
    else
      redirect_to account_help_support_request_url(@support_request), success: "Please try again."
    end
  end

private

  def set_support_request
    @support_request ||= SupportRequest.find_by(guid: params[:support_request_guid])
  end


  def current_resource
    @current_resource ||= SupportRequest.find_by(guid: params[:support_request_guid]) if params[:support_request_guid]
  end

end
