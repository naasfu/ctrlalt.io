class Admin::Help::SupportRequestsController < Admin::AdminController
  before_action :set_support_request, only: [:transition_workflow, :show, :edit, :update, :destroy]

  def transition_workflow
    @support_request.send("#{params[:event]}!") if params[:event]
    redirect_to admin_help_support_request_url(@support_request)
  end

  def index
    @tags              ||= SupportRequest.all.map(&:tags).flatten.uniq
    
    @open_count        ||= SupportRequest.with_open_state.size
    @resolved_count    ||= SupportRequest.with_resolved_state.size
    @on_hold_count     ||= SupportRequest.with_on_hold_state.size
    @comment_count     ||= Comment.all.size

    # Begin search
    @results ||= SupportRequest.all

    if params[:workflow_state]
      @results = @results.where(workflow_state: params[:workflow_state])
    end

    if params[:keyword]
      @results = @results.where('subject @@ :keyword OR content @@ :keyword', keyword: params[:keyword])
    end

    @results = @results.newest.page(params[:page]).per(10)
  end

  def show
    @comments                = @support_request.comments.oldest
    @comment                 = Comment.new
    @user                    = @support_request.user
    @recent_orders           = @user.orders.sorted
    @recent_bro_orders       = @user.bro_orders.not_incomplete.by_submitted_at
    @recent_support_requests = @user.support_requests.newest.where.not(id: @support_request.id)
  end

  def edit
  end

  def update
    if @support_request.update_attributes(support_request_params)
      redirect_to edit_admin_help_support_request_url(@support_request), success: "Support request updated."
    else
      render :edit
    end
  end

  def destroy
    flash.now[:success] = "Support request destroyed." if @support_request.destroy
  end

private

  def search_query
    query = ''
    options.each do |attribute|
      query += "#{attribute} @@ :search OR "
    end
    query[0..-4] # Remove the appended ' OR '
  end

  def set_support_request
    @support_request = SupportRequest.find_by(guid: params[:guid])
  end

  def support_request_params
    params.require(:support_request).permit!
  end
end
