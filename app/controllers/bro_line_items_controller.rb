class BroLineItemsController < ApplicationController

  # Setup @line_item.
  before_action :set_line_item, only: [:update, :destroy]

  # POST /bro_line_items
  def create
    # Setup @variant.
    @variant = BroVariant.includes(:product).find(params[:variant_id])

    begin
      # Add kap to kwk cart.
      AddBroVariantToCart.call(params[:variant_id], current_bros)

      flash.now[:success] = t(".added_to_cart")
    rescue => e
      # Catch errors from AddKwkCariantToCart.
      flash.now[:error] = e.message
    end
  end

  # DELETE /bro_line_item/:id
  def destroy
    # Remove @line_item from cart.
    @line_item.destroy
    flash.now[:success] = t('.removed_from_cart')
  end

private

  # Setup @line_item.
  def set_line_item
    @line_item ||= current_bros.line_items.find_by(id: params[:id])
  end

end
