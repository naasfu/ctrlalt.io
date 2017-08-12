class Admin::SendNewslettersController < Admin::AdminController

  before_action :set_newsletter

  def show
    @newsletter.update_attribute(:last_sent_at, Time.zone.now)

    SendNewsletterJob.perform_later(@newsletter)
    
    redirect_to admin_newsletter_url(@newsletter), success: "Newsletter sent!"
  end

private

  def set_newsletter
    @newsletter ||= Newsletter.find_by(slug: params[:slug])
  end

end
