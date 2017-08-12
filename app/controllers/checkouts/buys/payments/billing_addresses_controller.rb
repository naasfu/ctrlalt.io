class Checkouts::Buys::Payments::BillingAddressesController < Checkouts::CheckoutsController
  def edit
    @billing_address = current_cart.billing_address
  end

  def update
    @billing_address = current_cart.billing_address

    if @billing_address.update_attributes(billing_address_params)
      @credit_card = current_cart.card
    end
  end

private

  def billing_address_params
    params.require(:billing_address).permit(:full_name, :street1, :street2, :city, :state, :zip, :phone, :country, :verified)
  end
end
