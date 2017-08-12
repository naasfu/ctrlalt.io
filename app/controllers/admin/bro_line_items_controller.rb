class Admin::BroLineItemsController < Admin::AdminController
  before_action :set_bro_line_item

  def update
    @bro_line_item.update(tru_bro_id: params[:bro_line_item][:tru_bro_id])
    # render nothing: true
  end

private

  def set_bro_line_item
    @bro_line_item = BroLineItem.find(params[:id])
  end
end
