class KwkFulfillmentMailer < ApplicationMailer
  
  default from: "Kult Worship Kaps <brocaps@#{ENV['app_url']}>"

  def shipping(fulfillment)
    @fulfillment      = fulfillment
    @order            = @fulfillment.kwk_order
    @shipping_address = @fulfillment.shipping_address
    @line_items       = @fulfillment.line_items
    mail(to: @order.email, subject: "Your Kult Worship Kaps are on the way!")
  end

end