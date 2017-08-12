class GeocodeShippingAddressJob < ActiveJob::Base
  queue_as :geocodes

  def perform(shipping_address)
    GeocodeShippingAddress.call(shipping_address)
  end
end
