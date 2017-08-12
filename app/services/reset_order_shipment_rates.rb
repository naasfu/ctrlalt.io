class ResetOrderShipmentRates
  def self.call(order)
    shipment_id = order.shipping_address.present? ? order.new_shipment.id : nil
    order.update_attributes(rate_id: nil, shipment_id: shipment_id)
  end
end