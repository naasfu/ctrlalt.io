class BroFulfillmentMailerPreview < ActionMailer::Preview
  def shipping
    BroFulfillmentMailer.shipping(BroFulfillment.with_shipping_state.last)
  end

  def shipment_delivered
    FulfillmentMailer.shipment_delivered(Fulfillment.with_shipping_state.last)
  end
end