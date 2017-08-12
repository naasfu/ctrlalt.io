class Admin::Help::CommentsController < Admin::AdminController
  before_action :set_comment, only: [:edit, :update, :destroy]

  def index
    @results ||= Comment.all

    if params[:keyword]
      @results = @results.where('content @@ :keyword', keyword: params[:keyword])
    end

    @results = @results.newest.page(params[:page]).per(10)
  end

  def create
    @support_request ||= SupportRequest.find_by(guid: params[:support_request_guid])

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

    redirect_to admin_help_support_request_url(@support_request)
  end

  def edit
  end

  def update
    @comment.update_attributes(comment_params)
  end

  def destroy
    flash.now[:success] = "This comment has been removed." if @comment.destroy
  end

private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def set_comment
    @comment ||= Comment.find(params[:id])
  end

end
