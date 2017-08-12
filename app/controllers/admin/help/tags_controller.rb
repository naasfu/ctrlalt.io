class Admin::Help::TagsController < Admin::AdminController
  before_action :set_support_request, only: [:create, :destroy]

  def show
    @support_requests = SupportRequest.where.contains(tags: [params[:tag]])
  end

  def create
    if params[:tag_list].present?
      @support_request.tags = (@support_request.tags + params[:tag_list].split(',').map(&:parameterize)).uniq
      @support_request.save
    end
  end

  def destroy
    if params[:tag]
      @support_request.tags.delete(params[:tag])
      @support_request.save
    end
  end

private

  def set_support_request
    @support_request ||= SupportRequest.find_by(guid: params[:support_request_guid])
  end
end
