class Admin::OrdersController < Admin::AdminController
  before_action :set_order, only: [:transition_workflow, :show]

  include OrderSearch

  # POST /admin/orders/:guid/transition_workflow
  def transition_workflow
    @order.send("#{params[:event]}!") if params[:event]
  end

  # GET /admin/orders
  def index
    @orders = search_orders(params).page(params[:page])
  end

  # GET /admin/orders/:guid
  def show
    @fulfillments     = @order.fulfillments
    @notes            = @order.notes.newest
    @tracking_notes   = @order.tracking_notes
    @line_items       = @order.line_items
    @shipping_address = @order.shipping_address
    @billing_address  = @order.billing_address
    @shipment_service = @order.shipment_service
    @transactions     = @order.transactions
    @user             = @order.user
    @user_orders      = @user.orders.sorted.where.not(id: @order.id)
  end

private

  def set_order
    @order = Order.find_by(guid: params[:guid])
  end
end
