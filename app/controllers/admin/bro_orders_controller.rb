class Admin::BroOrdersController < Admin::AdminController
  before_action :set_bro_order, only: [:transition_workflow, :show]

  include BroOrderSearch

  def transition_workflow
    @bro_order.send("#{params[:event]}!") if params[:event]
  end

  def index
    @bro_orders = search_orders(params, BroOrder.sorted).page(params[:page])
  end

  def show
    @approved_line_items = @bro_order.line_items.approved
    @notes               = @bro_order.notes.newest
    @line_items          = @bro_order.line_items
    @shipping_address    = @bro_order.shipping_address
    @fulfillments        = @bro_order.fulfillments
    @user_orders = if @bro_order.user
      @bro_order.user.bro_orders.sorted.where.not(id: @bro_order.id)
    else
      nil
    end
  end

private

  def set_bro_order
    @bro_order = BroOrder.find_by(guid: params[:guid])
  end
end
