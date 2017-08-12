class KwkFulfillment < ActiveRecord::Base
  include HasGuid
  include Workflow
  include Fulfillable

  belongs_to :kwk_order
  has_one :shipping_address, through: :kwk_order

  validates_presence_of :tracking_number

  def item_count
    line_items.count
  end

  def line_items
    kwk_order.line_items.where(id: line_item_ids)
  end

  # Workflow callbacks
  def ship
    update_attribute(:shipped_at, Time.zone.now)
    KwkFulfillmentMailer.shipping(self).deliver_later
  end

end
