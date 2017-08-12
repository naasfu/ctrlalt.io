class InquiriesController < ApplicationController

  # GET /contact
  def new
    # Setup @inquiry for contact form.
    @inquiry = Inquiry.new
  end

  # POST /contact
  def create
    # Initialize a new Inquiry with form params.
    @inquiry = Inquiry.new(inquiry_params)

    # Attach current_user to Inquiry.
    @inquiry.user = current_user if current_user

    # Save the Inquiry or render the form again with @inquiry.
    if @inquiry.save
      # Ping our private Slack support channel.
      PingSlackInquiriesJob.perform_later(@inquiry, admin_inquiry_url(@inquiry))

      # Send email to support admins.
      InquiryMailer.send_copy_to_admins(@inquiry)
    end
  end

private
  
  # Strong params.
  def inquiry_params
    params.require(:inquiry).permit(:subject, :email, :name, :content)
  end

end
