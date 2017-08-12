class Checkouts::Buys::PurchasesController < Checkouts::CheckoutsController
  before_action :ensure_user_signed_in
  
  def new
    @shipping_address = current_cart.shipping_address
    @billing_address  = current_cart.billing_address
    @credit_card      = current_cart.card
    @line_items       = current_cart.line_items
    @shipping_rates   = EasypostSelectPresenter.new(current_cart)
  end

  def create
    errors = []
    errors << "Please provide a valid shipping address." if current_cart.shipping_address.blank?
    errors << "Please select a shipping rate."           if current_cart.rate_id.blank?
    errors << "Please add a payment method."             if current_cart.card.blank?
    errors << "Please provide a valid billing address."  if current_cart.billing_address.blank?

    if errors.any?
      redirect_to checkouts_buys_purchase_url, error: errors.first
    else
      @order = current_cart

      begin
        customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
        
        UpdateCardBillingAddress.call(customer, @order)

        charge = Stripe::Charge.create(
          customer: customer.id,
          amount: @order.grand_total_in_cents,
          currency: 'usd',
          metadata: { 
            order_id: @order.guid,
            ip_address: request.remote_ip
          }
        )

        @order.transactions.create({
          amount: @order.grand_total,
          charge_id: charge.id,
          last_4: charge.source.last4,
          full_name: charge.source.name,
          card_brand: charge.source.brand
        })

        @order.charge_id         = charge.id
        @order.email             = current_user.email
        @order.user              = current_user
        @order.placed_at         = Time.zone.now
        @order.paid_at           = Time.zone.now
        @order.ip_address        = request.remote_ip
        @order.shipping_amount   = @order.shipping_total
        @order.line_items_amount = @order.line_items_total
        @order.fee_amount        = @order.fee_total
        @order.save

        @order.payment_successful!

        UpdateInventoryStockJob.perform_later(@order)
        OrderMailer.payment_receipt(@order).deliver_later

        redirect_to account_history_order_url(@order), success: "Thanks for your order! We just sent a receipt to #{current_user.email}."
      rescue Stripe::CardError => e
        redirect_to checkouts_buys_purchase_url, error: e.json_body[:error][:message]
      rescue Stripe::RateLimitError => e
        redirect_to checkouts_buys_purchase_url, error: "We had trouble proccessing your request. Please try again. (Too many requests)"
      rescue Stripe::InvalidRequestError => e        
        redirect_to checkouts_buys_purchase_url, error: "We had trouble proccessing your request. Please try again. (Invalid request)"
      rescue Stripe::AuthenticationError => e
        redirect_to checkouts_buys_purchase_url, error: "We had trouble proccessing your request. Please try again. (Invalid session)"
      rescue Stripe::APIConnectionError => e
        redirect_to checkouts_buys_purchase_url, error: "We had trouble proccessing your request. Please try again. (Could not connect)"
      rescue Stripe::StripeError => e
        redirect_to checkouts_buys_purchase_url, error: "We had trouble proccessing your request. Please try again."
      rescue
        redirect_to checkouts_buys_purchase_url, error: "We had trouble proccessing your request. Please try again."
      end
    end
  end

private
  
  def ensure_user_signed_in
    unless current_user
      redirect_to login_url(return_to: checkouts_purchase_url), error: "Please login first."
    end
  end

end
