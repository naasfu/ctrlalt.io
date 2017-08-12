class KwkFulfillmentMailerPreview < ActionMailer::Preview
  def shipping
    KwkFulfillmentMailer.shipping(KwkFulfillment.with_shipping_state.last)
  end
end