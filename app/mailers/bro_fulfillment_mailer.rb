class BroFulfillmentMailer < ApplicationMailer
  default from: "Bro Caps <brocaps@#{ENV['app_url']}>"

  def shipping(fulfillment)
    @fulfillment      = fulfillment
    @bro_order        = @fulfillment.bro_order
    @shipping_address = @fulfillment.shipping_address
    @line_items       = @fulfillment.line_items
    mail(to: @bro_order.email, subject: "Your Bro Caps are on the way!")
  end

  def shipment_delivered(fulfillment)
    @fulfillment      = fulfillment
    @bro_order        = @fulfillment.order
    @shipping_address = @fulfillment.shipping_address
    @line_items       = @fulfillment.line_items
    mail(to: @bro_order.email, subject: "#{short_guid @order} Shipment delivered")
  end
end