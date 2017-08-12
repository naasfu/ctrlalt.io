class Account::Help::SupportRequestsController < Account::AccountsController
  before_action :set_support_request, only: [:show]

  def index
    support_requests = current_user.support_requests

    @open_support_requests   = support_requests.with_open_state.newest
    @closed_support_requests = support_requests.with_closed_state.newest
    @popular_faqs            = Faq.popular.limit(5)
  end

  def new
    @support_request = current_user.support_requests.build
  end

  def create
    @support_request = current_user.support_requests.build(support_request_params)
    @support_request.subject = "(No subject)" if @support_request.subject.blank? && @support_request.valid?

    if @support_request.save
      SupportRequestMailer.opened(@support_request).deliver_later
      redirect_to account_help_support_request_url(@support_request), success: "Your support request has been opened."
    else
      render :new
    end
  end

  def show
    @comments = @support_request.comments.oldest
    @comment  = Comment.new
  end

private

  def support_request_params
    params.require(:support_request).permit(:subject, :content)
  end

  def set_support_request
    @support_request ||= SupportRequest.find_by(guid: params[:guid])
  end

  def current_resource
    @current_resource ||= SupportRequest.find_by(guid: params[:guid]) if params[:guid]
  end

end
