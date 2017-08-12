class BroLineItemPositionsController < ApplicationController

  # Setup @bro_line_item.
  before_action :set_bro_line_item

  # GET /bro_line_item/:id/move_up
  def move_up
    @bro_line_item.move_higher
  end
  
  # GET /bro_line_item/:id/move_down
  def move_down
    @bro_line_item.move_lower
  end


private

  # Setup @bro_line_item.
  def set_bro_line_item
    @bro_line_item ||= current_bros.line_items.find_by(id: params[:id])
  end

end
