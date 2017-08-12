class ChargeOrderByCard
  def self.call(token, order, user, ip_address)
    # The customer can be:
    #   A guest, a user that is not logged in.
    #   A registered user who has not purchased yet, (stripe_customer_id is not set).
    #   A regsitered user who has made a purchase previously (stripe_customer_id is set).
    if user && user.stripe_customer_id.blank?
      # New registered customer
      customer = Stripe::Customer.create(
        card: token,
        email: user.email,
        metadata: { user_id: user.id }
      )
      user.update_attribute(:stripe_customer_id, customer.id)
    elsif user && user.stripe_customer_id.present?
      # Previous customer
      customer = Stripe::Customer.retrieve(user.stripe_customer_id)
      # To use the current token
      # it needs to be saved to the stripe customer object
      customer.card = token
      customer.save
    else
      # Guest customer
      customer = Stripe::Customer.create(card: token)
    end

    order.user       = user if user
    order.ip_address = ip_address
    order.save

    charge = Stripe::Charge.create(
      customer: customer.id,
      amount: order.grand_total_in_cents,
      currency: 'usd',
      metadata: { 
        order_id: order.guid,
        ip_address: ip_address
      }
    )
  end
end