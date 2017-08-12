class Checkouts::Kwk::SubmissionsController < Checkouts::KwkController

  def new
    if current_kaps.line_items.any?
      @shipping_address = current_kaps.shipping_address
      @line_items       = current_kaps.line_items.sorted
    else
      redirect_to checkouts_kwk_url, error: "You don't have any kaps in your cart."
    end
  end

  def create
    errors = []
    errors << "A valid geekhack username is required."   if current_kaps.geekhack_username.blank?
    errors << "Please provide a valid shipping address." if current_kaps.shipping_address.blank?

    if errors.any?
      redirect_to checkouts_kwk_submit_url, error: errors.first
    else
      @order = current_kaps
      @order.update_attributes(user: current_user, email: current_user.email)
      if @order.incomplete?
        @order.submit! 
        @order.update_attribute(:submitted_at, Time.zone.now)
        # KwkOrderMailer.submitted(@order).deliver_later
      end
      redirect_to account_history_kwk_order_url(@order), success: "Thanks for submitting your ticket. You will be notified if any of your kaps are chosen."
    end
  end

end
