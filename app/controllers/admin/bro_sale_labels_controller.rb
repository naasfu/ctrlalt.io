class Admin::BroSaleLabelsController < Admin::AdminController
  before_action :set_bro_sale

  def purchase
    @orders = @bro_sale.orders.sorted.includes(:shipping_address).where.not('addresses.country' => 'US')

    @orders.each do |order|
      if order.workflow_state == 'paid' && order.fulfillments.size == 0
        fulfillment = order.fulfillments.build(
                        line_item_ids: order.line_items.approved.map(&:id)
                      )
        if fulfillment.save
          shipment = fulfillment.shipment

          label = shipment.buy(rate: shipment.lowest_rate)

          if label
            fulfillment.update_attributes(
              tracking_number: label.tracking_code, 
              shipment_id:     label.id
            )
            order.ship!       if order.paid?
            fulfillment.ship! if fulfillment.preparing?
          else
            order.shipment_failed!
          end
        end
      end
    end
  end

private

  def set_bro_sale
    @bro_sale = BroSale.find_by(slug: params[:slug])
  end
end
