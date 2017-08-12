class Admin::Kwk::KwkOrdersController < Admin::AdminController
  before_action :set_order, only: [:transition_workflow, :show]

  include KwkOrderSearch

  def transition_workflow
    @order.send("#{params[:event]}!") if params[:event]
  end

  def index
    @sale   ||= KwkSale.find_by(slug: params[:sale_slug])
    @orders ||= search_orders(params, @sale.orders.sorted).page(params[:page])
  end

  def show
    @sale                ||= @order.kwk_sales.first
    @approved_line_items ||= @order.line_items.approved.sorted
    @notes               ||= @order.notes.newest
    @line_items          ||= @order.line_items.sorted
    @shipping_address    ||= @order.shipping_address
    @fulfillments        ||= @order.fulfillments
    @user                ||= @order.user
  end

private

  def set_order
    @order ||= KwkOrder.find_by(guid: params[:guid])
  end

end
