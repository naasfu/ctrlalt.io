class Account::History::FulfillmentsController < ApplicationController
  # GET /account/fulfillments/:guid
  def show
    @fulfillment = Fulfillment.find_by(guid: params[:guid])
    @line_items  = @fulfillment.line_items
  end

private

  # Override current_resouce to the current order for authorization.
  def current_resource
    @current_resource ||= Fulfillment.find_by(guid: params[:guid]) if params[:guid]
  end
end
