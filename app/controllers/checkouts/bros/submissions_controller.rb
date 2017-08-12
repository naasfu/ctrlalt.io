class Checkouts::Bros::SubmissionsController < Checkouts::CheckoutsController

  def new
    if current_bros.line_items.any?
      @shipping_address = current_bros.shipping_address
      @line_items       = current_bros.line_items.sorted
    else
      redirect_to checkouts_bros_url, error: "You don't have any bros in your cart."
    end
  end

  def create
    errors = []
    errors << "A valid geekhack username is required."   if current_bros.geekhack_username.blank?
    errors << "Please provide a valid shipping address." if current_bros.shipping_address.blank?

    if errors.any?
      redirect_to checkouts_bros_submit_url, error: errors.first
    else
      @bro_order = current_bros
      @bro_order.update_attributes(user: current_user, email: current_user.email)
      if @bro_order.incomplete?
        @bro_order.submit! 
        @bro_order.update_attribute(:submitted_at, Time.zone.now)
        BroOrderMailer.submitted(@bro_order).deliver_later
      end
      redirect_to account_history_bro_order_url(@bro_order), success: "Thanks for submitting your ticket. You will be notified if any of your bros are chosen."
    end
  end

end
