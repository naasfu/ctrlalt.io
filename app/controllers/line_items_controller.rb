class LineItemsController < ApplicationController

  # Setup @line_item.
  before_action :set_line_item, only: [:update, :destroy]

  # POST /line_items
  def create
    if params[:variant_id]
      # The request includes the `:variant_id`.
      @variant = Variant.find_by(id: params[:variant_id])

      if @variant
        # The variant exsists.
        # Initalize the cart object to perform validations.
        cart_product = AddProductToCart.new(@variant, params[:quantity], current_cart)

        # Perform validations against the cart product.
        if cart_product.out_of_stock?
          # Out of stock.
          flash.now[:error] = t(".out_of_stock")

        elsif cart_product.quantity_over_stock?
          # The quantity exceeds the amount in stock.
          flash.now[:error] = t(".quantity_over_stock")

        elsif cart_product.quantity_over_limit?
          # The quantity exceeds the set limit for this variant.
          flash.now[:error] = "You can only purchase #{@variant.limit} per order."

        elsif cart_product.unavailable?
          # The active flag has been set to false on this variant or the stock 
          # has run out.
          flash.now[:error] = t(".unavailable")

        else
          # Add the variant to cart and return the new line_item.
          @line_item = cart_product.add

          # Reset previously selected shipping rate.
          ResetOrderShipmentRates.call(current_cart)

          # Added to cart.
          flash.now[:success] = t(".added_to_cart")
        end
      else
        # Variant not found.
        flash.now[:error] = t(".not_found")
      end
    else
      # No variant present.
      flash.now[:error] = t(".no_option_selected")
    end
  end

  # PATCH /line_items/:id
  def update
    # Update @line_item quantity.
    if @line_item.update_attributes(line_item_params)
      flash.now[:success] = t(".quantity_updated")
    end
  end

  # DELETE /line_items/:id
  def destroy
    # Remove @line_item from cart.
    @line_item.destroy
    flash.now[:success] = t(".removed_from_cart")
  end

private

  # Setup @line_item.
  def set_line_item
    @line_item = current_cart.line_items.find_by(id: params[:id])
  end

  # Strong params.
  def line_item_params
    params.require(:line_item).permit(:quantity)
  end
end
