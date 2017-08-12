class BroFulfillment < ActiveRecord::Base
  include HasGuid
  include Workflow
  include BroEasypostable
  include Fulfillable

  attr_accessor :selected_service_name

  belongs_to :bro_order
  has_one :shipping_address, through: :bro_order

  def item_count
    line_items.count
  end

  def line_items
    bro_order.line_items.where(id: line_item_ids)
  end

  # Workflow callbacks
  def ship
    update_attribute(:shipped_at, Time.zone.now)
    line_items.update_all(shipped: true)
    bro_order.ship! if bro_order.paid?
    BroFulfillmentMailer.shipping(self).deliver_later
  end

  def refund
    shipment.refund if shipment
  end
end
