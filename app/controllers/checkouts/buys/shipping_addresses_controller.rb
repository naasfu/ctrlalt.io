class Checkouts::Buys::ShippingAddressesController < Checkouts::CheckoutsController
  before_action :set_shipping_address, only: [:verify, :edit, :update, :destroy]

  def verify
    verified = params[:verified].to_i > 0
    @shipping_address.update_attribute(:verified, verified)
    head :ok, content_type: "text/html"
  end

  def new
    @shipping_address = current_user.shipping_addresses.build
  end

  def create
    @shipping_address = current_user.shipping_addresses.build(shipping_address_params)

    # Verify address.
    @shipping_address.verified = @shipping_address.verified_address?

    if @shipping_address.save
      # Create billing address.
      @billing_address = current_user.billing_addresses.create(shipping_address_params)
      current_cart.update_attribute(:billing_address, @billing_address)

      # Attach address to current order.
      current_cart.update_attribute(:shipping_address, @shipping_address)

      # Reset shipping rates incase the user previously selected a rate.
      ResetOrderShipmentRates.call(current_cart)

      # Get new rates.
      @shipping_rates = EasypostSelectPresenter.new(current_cart)

      # Geocode address
      GeocodeShippingAddressJob.perform_later(@shipping_address)
    end
  end

  def edit
  end

  def update
    @shipping_address.assign_attributes(shipping_address_params)
    
    # Verify address.
    @shipping_address.verified = @shipping_address.verified_address?

    # Update address.
    if @shipping_address.save
      # Reset shipping rates incase the user previously selected a rate.
      ResetOrderShipmentRates.call(current_cart)

      # Get new rates.
      @shipping_rates = EasypostSelectPresenter.new(current_cart)

      # Geocode address
      GeocodeShippingAddressJob.perform_later(@shipping_address)
    end
  end

  def destroy
  end

private

  def set_shipping_address
    @shipping_address = ShippingAddress.find(params[:id])
  end

  def shipping_address_params
    params.require(:shipping_address).permit(:full_name, :street1, :street2, :city, :state, :zip, :phone, :country, :verified)
  end
end
