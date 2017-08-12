class Account::History::KwkOrdersController < Account::AccountsController
  before_action :set_order, only: [:show, :pay]

  def index
    @orders = current_user.kwk_orders.not_incomplete.by_submitted_at
  end

  def show
    @approved_line_items = @order.line_items.approved.sorted
    @fulfillments          = @order.fulfillments.newest
    @line_items          = @order.line_items.sorted
    @shipping_address    = @order.shipping_address
  end

  def pay
    if @order.workflow_state == "winner"
      render layout: 'empty'
    else
      redirect_to account_history_kwk_order_url(@order)
    end
  end

private
  
  def set_order
    @order = KwkOrder.find_by(guid: params[:guid])
  end

  # Override current_resouce to the current order for authorization.
  def current_resource
    @current_resource ||= KwkOrder.find_by(guid: params[:guid])
  end
end
