class Account::History::OrdersController < ApplicationController

  before_action :set_order

  def index
    @orders       ||= current_user.orders.sorted
    @order_months ||= @orders.group_by { |o| o.paid_at.beginning_of_month }.sort.reverse
  end

  def show
    @transactions = @order.transactions.newest
    @shipping_address = @order.shipping_address
    @fulfillments = @order.fulfillments
    @tracking_notes = @order.tracking_notes
  end

private

  def set_order
    @order = Order.find_by(guid: params[:guid])
  end

  def current_resource
    @current_resource ||= Order.find_by(guid: params[:guid]) if params[:guid]
  end

end
