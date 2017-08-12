class Admin::FulfillmentsController < Admin::AdminController
  before_action :set_order
  before_action :set_fulfillment, only: [:transition_workflow, :print, :show, :edit, :update]

  # POST /admin/orders/:order_guid/fulfillments/:guid/transition_workflow
  def transition_workflow
    @fulfillment.send("#{params[:event]}!") if params[:event]
  end

  def print
    if params[:label].present?
      CreatePrintnodeService.call(
        @fulfillment.label_zpl_url,
        @fulfillment.tracking_number,
        ENV['label_printer'],
        'raw_uri',
        'CTRLALT'
      )
    end
    
    if params[:invoice].present?
      CreatePrintnodeService.call(
        admin_order_fulfillment_url(@order, @fulfillment, format: :pdf),
        "FUL##{@fulfillment.guid.upcase} INVOICE",
        ENV['invoice_printer']
      )
    end
  end

  def show
    pdf = FulfillmentInvoicePdf.new(@fulfillment)
    send_data pdf.render, filename: "invoice_#{@fulfillment.guid.upcase}.pdf", type: 'application/pdf', disposition: 'inline'
  end

  def new
    line_item_ids = if params[:line_item_ids].blank? 
      @order.line_items.map(&:id)
    else
      params[:line_item_ids]
    end

    @fulfillment = @order.fulfillments.new(line_item_ids: line_item_ids)
    @fulfillment.weight = params[:weight].to_f if params[:weight].present?
    @line_items = @fulfillment.line_items
    @rates = EasypostSelectPresenter.new(@fulfillment, false)
  end

  # POST /admin/orders/:order_guid/fulfillments
  def create
    @rate     = EasyPost::Rate.retrieve(params[:fulfillment][:rate_id])
    @shipment = EasyPost::Shipment.retrieve(@rate.shipment_id)

    @shipment.buy(rate: @rate)
    
    @fulfillment = @order.fulfillments.new

    @fulfillment.line_item_ids    = params[:line_item_ids].split(" ").map(&:to_i)
    @fulfillment.notes            = params[:fulfillment][:notes]
    @fulfillment.weight           = @shipment.parcel.weight
    @fulfillment.rate_id          = @rate.id
    @fulfillment.shipment_id      = @shipment.id
    @fulfillment.shipment_service = @rate.service.underscore.humanize
    @fulfillment.cost             = @rate.rate.to_f
    @fulfillment.shipped_at       = Time.zone.now
    @fulfillment.tracking_number  = @shipment.tracking_code
    
    @fulfillment.save

    @fulfillment.begin_transit!

    @order.ship! if @order.paid?

    FulfillmentMailer.in_transit(@fulfillment).deliver_later

    if params[:print_label].present?
      CreatePrintnodeService.call(
        @fulfillment.label_zpl_url,
        @fulfillment.tracking_number,
        ENV['label_printer'],
        'raw_uri'
      )
    end

    if params[:print_invoice].present?
      CreatePrintnodeService.call(
        admin_order_fulfillment_url(@order, @fulfillment, format: :pdf),
        "FUL##{@fulfillment.guid.upcase} INVOICE",
        ENV['invoice_printer']
      )
    end
  end

private

  def set_fulfillment
    @fulfillment = Fulfillment.find_by(guid: params[:guid])
  end

  def set_order
    @order = Order.find_by(guid: params[:order_guid])
  end
end
