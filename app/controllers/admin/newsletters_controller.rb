class Admin::NewslettersController < Admin::AdminController

  before_action :set_newsletter, only: [:show, :edit, :update, :destroy]

  def index
    @newsletters ||= Newsletter.newest.page(params[:page])
  end

  def show
    @group_buy ||= @newsletter.group_buy
  end

  def new
    @newsletter = Newsletter.new
  end

  def create
    @newsletter = Newsletter.new(newsletter_params)

    if @newsletter.save
      redirect_to admin_newsletter_url(@newsletter), success: "Newsletter created. Make sure it looks good before sending."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @newsletter.update_attributes(newsletter_params)
      redirect_to admin_newsletter_url(@newsletter), success: "Newsletter updated."
    else
      render :edit
    end
  end

  def destroy
    @newsletter.destroy if @newsletter
  end

private

  def set_newsletter
    @newsletter ||= Newsletter.find_by(slug: params[:slug])
  end

  def newsletter_params
    params.require(:newsletter).permit!
  end

end
