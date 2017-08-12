class Admin::Kwk::KwkFulfillmentsController < Admin::AdminController
  before_action :set_order

  def new
    @fulfillment = @order.fulfillments.build
    @line_items  = @order.line_items.approved.sorted
  end

  def create
    @fulfillment = @order.fulfillments.build(fulfillment_params)
    @line_items  = @order.line_items.approved
    @fulfillment.line_item_ids = @line_items.map(&:id)
    @fulfillment.service_name = "Royal Mail Express"

    if @fulfillment.save
      @line_items.update_all(shipped: true)
      @order.ship! if @order.paid?
      @fulfillment.ship! if @fulfillment.preparing?
    end
  end

private

  def fulfillment_params
    params.require(:kwk_fulfillment).permit!
  end

  def set_order
    @order = KwkOrder.find_by(guid: params[:order_guid])
  end
end
