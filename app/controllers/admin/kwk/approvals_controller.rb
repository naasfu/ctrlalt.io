class Admin::Kwk::ApprovalsController < Admin::AdminController
  before_action :set_order

  def create
    @approved_line_items = KwkLineItem.where(id: params[:kwk_line_item_ids])
    @approved_line_items.update_all(approved: true)
    @order.approve! if @order.submitted?
  end

private

  def set_order
    @order = KwkOrder.find_by(guid: params[:order_guid])
  end
end
