class Checkouts::Bros::BroLineItemsController < Checkouts::CheckoutsController
  
  before_action :set_bro_line_item

  def destroy
    if @line_item
      @line_item.destroy
      flash.now[:success] = 'This bro has been removed from your cart.'
    else
      flash.now[:error] = 'Could not remove this bro from your cart, it may have been removed already.'
    end
  end

private

  def set_bro_line_item
    @line_item = current_bros.line_items.find(params[:id])
  end

end
