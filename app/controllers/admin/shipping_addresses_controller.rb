class Admin::ShippingAddressesController < Admin::AdminController

  before_action :set_shipping_address
  
  def edit
  end

  def update
    @shipping_address.update_attributes(shipping_address_params)
  end

private

  def set_shipping_address
    @shipping_address ||= ShippingAddress.find(params[:id])
  end

  def shipping_address_params
    params.require(:shipping_address).permit!
  end

end
