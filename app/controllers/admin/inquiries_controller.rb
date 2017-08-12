class Admin::InquiriesController < Admin::AdminController
  before_action :set_inquiry, only: [:show]

  def index
    results = Inquiry.all

    if params[:workflow_state].present?
      results = results.where(workflow_state: params[:workflow_state])
    end

    if params[:keyword].present?
      results = results.where(
        inquiry_search_query(['subject', 'name', 'content', 'email']),
        search: "%#{params[:keyword]}%"
      )
    end

    @inquiries = results.newest.page(params[:page])
  end

  def show
    @inquiries = Inquiry.where(email: @inquiry.email).where.not(id: @inquiry.id).newest
  end

private

  def set_inquiry
    @inquiry = Inquiry.find_by(guid: params[:guid])
  end

  def inquiry_search_query(options=[])
    query = ''
    options.each do |attribute|
      query += "#{attribute} LIKE :search OR "
    end
    query[0..-4] # Remove the appended ' OR '
  end
end
