class FulfillmentMailerPreview < ActionMailer::Preview
  def in_transit
    FulfillmentMailer.in_transit(KwkFulfillment.first)
  end

  def shipment_delivered
    FulfillmentMailer.shipment_delivered(KwkFulfillment.first)
  end
end