class Admin::BroFulfillmentsController < Admin::AdminController
  before_action :set_bro_order
  before_action :set_fulfillment, only: [:transition_workflow, :invoice, :edit, :update]

  def transition_workflow
    @fulfillment.send("#{params[:event]}!") if params[:event]
  end

  def invoice
    @bro_order        = @fulfillment.order
    @line_items       = @fulfillment.line_items
    @shipping_address = @bro_order.shipping_address
    @shipment_service = @bro_order.shipment_service
    render layout: 'admin/fulfillment_invoice'
  end

  def create
    if @bro_order
      line_item_ids = if params[:bro_line_item_ids].blank? 
        @bro_order.line_items.map(&:id)
      else
        params[:bro_line_item_ids]
      end

      @fulfillment = @bro_order.fulfillments.create(line_item_ids: line_item_ids)

      if @fulfillment
        @line_items = @fulfillment.line_items
      else
        flash.now[:error] = 'Could not build fulfillment.'
      end
    else
      flash.now[:error] = 'Could not find order.'
    end
  end

  def edit
    @line_items = @fulfillment.line_items
  end

  def update
    @bro_order = @fulfillment.bro_order
    @shipment  = @fulfillment.shipment
    @label = if @fulfillment.shipment_id.present?
      nil
    else
      @shipment.buy(rate: @shipment.lowest_rate)
    end

    if @label
      @fulfillment.update_attributes(
        tracking_number: @label.tracking_code, 
        shipment_id:     @label.id
      )
      @bro_order.ship!   if @bro_order.paid?
      @fulfillment.ship! if @fulfillment.preparing?
    else
      flash.now[:error] = 'No rates found or already purchased.'
    end
  end

private

  def set_fulfillment
    @fulfillment = BroFulfillment.find_by(guid: params[:guid])
  end

  def set_bro_order
    @bro_order = BroOrder.find_by(guid: params[:bro_order_guid])
  end
end
