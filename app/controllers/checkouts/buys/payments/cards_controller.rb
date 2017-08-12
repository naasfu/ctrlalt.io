class Checkouts::Buys::Payments::CardsController < Checkouts::CheckoutsController

  def new
    @shipping_address = current_cart.shipping_address
    if @shipping_address.present?
      @credit_card = current_user.cards.build
    else
      flash.now[:error] = "Please add a shipping address first."
    end
  end

  def create
    # Retrieve card details via token.
    token_card = Stripe::Token.retrieve(params[:token]).try(:card)

    # Get the fingerprint of the card.
    fingerprint = token_card.try(:fingerprint)

    # Create a new card for the current user.
    @credit_card = current_user.cards.create(fingerprint: fingerprint)

    if current_user.stripe_customer_id.blank?
      # New customer
      customer = Stripe::Customer.create(
        card:  params[:token],
        email: current_user.email,
        metadata: { user_id: current_user.id }
      )

      current_user.update_attribute(:stripe_customer_id, customer.id)
    else
      # Previous customer
      customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
      customer.card = params[:token]
      customer.save
    end
    
    current_cart.update_attribute(:card, @credit_card)
    
    @billing_address = current_cart.billing_address
  # rescue Stripe::CardError => e
  #   # Invalid card
  #   flash.now[:error] = "Please try again. (Invalid card details)"
  # rescue Stripe::InvalidRequestError => e
  #   # Invalid parameters were supplied to Stripe's API
  #   flash.now[:error] = "Please try again. (Invalid parameters)"
  # rescue Stripe::AuthenticationError => e
  #   # Authentication with Stripe's API failed
  #   # (maybe you changed API keys recently)
  #   flash.now[:error] = "Please try again. (Authentication error)"
  # rescue Stripe::APIConnectionError => e
  #   # Network communication with Stripe failed
  #   flash.now[:error] = "Please try again. (Communication error)"
  # rescue Stripe::StripeError => e
  #   # Display a very generic error to the user, and maybe send
  #   # yourself an email
  #   flash.now[:error] = "Please try again."
  # rescue => e
  #   flash.now[:error] = "Please try again."
  end
end
