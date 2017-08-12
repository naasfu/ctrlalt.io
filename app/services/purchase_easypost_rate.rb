class PurchaseEasypostRate
  def self.call(fulfillment, shipment_service_name)
    label = fulfillment.shipment
    rate  = label.rates.select{ |r| r['service'] == shipment_service_name }.first
    label.buy(rate: rate)
  end
end