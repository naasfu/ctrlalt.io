class KwkLineItemPositionsController < ApplicationController

  # Setup @kwk_line_item.
  before_action :set_kwk_line_item

  # GET /kwk_line_item/:id/move_up
  def move_up
    @kwk_line_item.move_higher
  end
  
  # GET /kwk_line_item/:id/move_down
  def move_down
    @kwk_line_item.move_lower
  end


private

  # Setup @kwk_line_item.
  def set_kwk_line_item
    @kwk_line_item ||= current_kaps.line_items.find_by(id: params[:id])
  end

end
