class Checkouts::Kwk::LineItemsController < Checkouts::KwkController
  
  before_action :set_line_item

  def destroy
    if @line_item
      @line_item.destroy
      flash.now[:success] = 'This kap has been removed from your kart.'
    else
      flash.now[:error] = 'Could not remove this kap from your kart, it may have been removed already.'
    end
  end

private

  def set_line_item
    @line_item = current_kaps.line_items.find(params[:id])
  end

end
