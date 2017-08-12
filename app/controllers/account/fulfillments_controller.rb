class Account::FulfillmentsController < ApplicationController
  def show
    @fulfillment = Fulfillment.find_by(guid: params[:guid])
    @line_items  = @fulfillment.line_items
  end

private

  # Override current_resouce to the current order for authorization.
  def current_resource
    @current_resource ||= Fulfillment.find_by(guid: params[:guid]).order
  end
end
