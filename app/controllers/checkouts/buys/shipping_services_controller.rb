class Checkouts::Buys::ShippingServicesController < Checkouts::CheckoutsController

  def reset_rates
    # Reset shipment rates.
    ResetOrderShipmentRates.call(current_cart)

    # Respond with nothing.
    head :no_content
  end


  def update
    # Update selected shipping service rate.
    current_cart.update_attribute(:rate_id, params[:rate_id])
  end

end