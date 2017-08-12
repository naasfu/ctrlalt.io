class FulfillmentMailer < ApplicationMailer
  default from: "[CTRL]ALT <orders@#{ENV['app_url']}>"

  def in_transit(fulfillment)
    @fulfillment      = fulfillment
    @order            = @fulfillment.order
    @shipping_address = @fulfillment.shipping_address
    @line_items       = @fulfillment.line_items
    mail(to: @order.email, subject: "##{@order.guid} is on the way!")
  end

  def shipment_delivered(fulfillment)
    @fulfillment      = fulfillment
    @order            = @fulfillment.order
    @shipping_address = @fulfillment.shipping_address
    @line_items       = @fulfillment.line_items
    mail(to: @order.email, subject: "##{@order.guid} Shipment delivered")
  end
end