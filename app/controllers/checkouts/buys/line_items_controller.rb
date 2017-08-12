class Checkouts::Buys::LineItemsController < Checkouts::CheckoutsController
  
  before_action :set_line_item

  def update
    @line_item.update_attributes(line_item_params)
    ResetOrderShipmentRates.call(current_cart)
  end

  def destroy
    if @line_item
      @line_item.destroy
      ResetOrderShipmentRates.call(current_cart)
    end
  end

private

  def set_line_item
    @line_item = current_cart.line_items.find(params[:id])
  end

  def line_item_params
    params.require(:line_item).permit(:quantity)
  end

end
