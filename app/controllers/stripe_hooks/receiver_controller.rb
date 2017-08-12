class StripeHooks::ReceiverController < ApplicationController

  # Stripe will send the receiver a POST requests with the charge or dispute
  # details.
  protect_from_forgery except: :receiver

  # POST /stripe/receiver
  def receiver
    # Parse the POST request from stripe.
    data_json = JSON.parse(request.body.read)

    # Retreive the event using the id and discard the rest.
    event = Stripe::Event.retrieve(data_json['id'])

    # The order guid is stored in stripes metadata for every order.
    # Stripe is only used for group buys and store purchases.
    order_id = event['data']['object']['metadata']['order_id']

    # Only respond to charge events.
    if event['data']['object']['object'] == 'charge'

      # Lookup order by the metadata order_id.
      order = Order.find_by(guid: order_id)

      if order
        # Order exsists.
        # Respond to different charge events.
        case event['type']

        # Charges
        # 
        when 'charge.succeeded'
          charge_id = event['data']['object']['id']
          StripeHandler::Charge.succeeded(order, charge_id)
        when 'charge.refunded'
          StripeHandler::Charge.refunded(order)

        # Disputes
        # 
        # when 'dispute.created'
        #   StripeHandler::Dispute.created(order)
        # when 'dispute.updated'
        #   StripeHandler::Dispute.updated(order)
        # when 'dispute.closed'
        #   StripeHandler::Dispute.closed(order)
        # when 'dispute.funds_reinstated'
        #   StripeHandler::Dispute.funds_reinstated(order)
        # when 'dispute.funds_withdrawn'
        #   StripeHandler::Dispute.funds_withdrawn(order)
        end
      end
    end

    render nothing: true, status: 200
  end
end