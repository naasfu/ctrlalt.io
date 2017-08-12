class Admin::BroApprovalsController < Admin::AdminController
  before_action :set_bro_order

  def create
    @approved_line_items = BroLineItem.where(id: params[:bro_line_item_ids])
    @approved_line_items.update_all(approved: true)
    @bro_order.approve! if @bro_order.submitted?
  end

private

  def set_bro_order
    @bro_order = BroOrder.find_by(guid: params[:bro_order_guid])
  end
end
