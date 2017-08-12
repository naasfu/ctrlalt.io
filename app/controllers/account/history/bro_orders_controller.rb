class Account::History::BroOrdersController < Account::AccountsController
  before_action :set_bro_order, only: [:show, :pay]

  def index
    @bro_orders = current_user.bro_orders.not_incomplete.by_submitted_at
  end

  def show
    @approved_line_items = @bro_order.line_items.approved.sorted
    @line_items          = @bro_order.line_items.sorted
    @shipping_address    = @bro_order.shipping_address
  end

  def pay
    render layout: 'empty'
  end

private
  
  def set_bro_order
    @bro_order = BroOrder.find_by(guid: params[:guid])
  end

  # Override current_resouce to the current order for authorization.
  def current_resource
    @current_resource ||= BroOrder.find_by(guid: params[:guid])
  end
end
