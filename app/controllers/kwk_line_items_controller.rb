class KwkLineItemsController < ApplicationController

  # Setup @kwk_line_item.
  before_action :set_kwk_line_item, only: [:destroy]

  # POST /kwk_line_item
  def create
    # Setup @variant.
    @variant = KwkVariant.includes(:product).find(params[:variant_id])

    begin
      # Add kap to kwk cart.
      AddKwkVariantToCart.call(params[:variant_id], current_kaps)

      flash.now[:success] = t(".added_to_cart")
    rescue => e
      # Catch errors from AddKwkCariantToCart.
      flash.now[:error] = e.message
    end
  end

  # DELETE /kwk_line_item/:id
  def destroy
    # Remove @kwk_line_item from cart.
    @kwk_line_item.destroy

    flash.now[:success] = t(".removed_from_cart")
  end

private

  # Setup @kwk_line_item.
  def set_kwk_line_item
    @kwk_line_item = current_kaps.line_items.find_by(id: params[:id])
  end

end
