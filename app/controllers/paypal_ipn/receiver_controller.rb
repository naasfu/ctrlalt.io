class PaypalIpn::ReceiverController < ApplicationController
  protect_from_forgery except: :receiver

  # POST /stripe/receiver
  def receiver
    bro_order = BroOrder.find_by(guid: params[:invoice])
    kwk_order = KwkOrder.find_by(guid: params[:invoice])

    PaypalNotification.create!(params: params, 
                            bro_order: bro_order, 
                            kwk_order: kwk_order, 
                               status: params[:payment_status], 
                       transaction_id: params[:txn_id])

    render nothing: true, status: 200
  end
end