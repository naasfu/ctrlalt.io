class Account::Help::CommentsController < Account::AccountsController
  before_action :set_support_request

  def create
    @comment = @support_request.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      @support_request.reopen! if @support_request.closed? || @support_request.resolved?
    
      unless @comment.user == @support_request.user
        SupportRequestMailer.new_reply(@support_request).deliver_later
      end
      
      flash[:success] = "Your response has been posted."
    else
      flash[:error] = "Your response can't be blank."
    end

    redirect_to account_help_support_request_url(@support_request)
  end

private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def set_support_request
    @support_request ||= SupportRequest.find_by(guid: params[:support_request_guid])
  end
end
