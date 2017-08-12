class Fulfillment < ActiveRecord::Base
  include HasGuid
  include Workflow
  include Easypostable

  attr_accessor :selected_service_name

  belongs_to :order
  has_one :shipping_address, through: :order

  scope :newest,        -> { order(created_at: :desc) }
  scope :not_preparing, -> { where.not(workflow_state: 'preparing') }
  scope :sorted,        -> { where.not(workflow_state: ['preparing', 'refunded']).newest }

  workflow do
    state :preparing do
      event :begin_transit, transition_to: :in_transit
      event :refund,        transition_to: :refunded
    end
    state :in_transit do
      event :begin_delivery, transition_to: :out_for_delivery
    end
    state :out_for_delivery do
      event :delivery_success, transition_to: :delivered
      event :delivery_failed, transition_to: :returned_to_sender
    end
    state :refunded
    state :returned_to_sender
  end

  def item_count
    line_items.to_a.sum(&:quantity)
  end

  def line_items
    order.line_items.where(id: line_item_ids)
  end

  # Workflow callbacks
  def begin_delivery
  end

  def refund
    shipment.refund if shipment
  end

  def total_weight_in_oz
    total_weight = if weight.present? 
      weight
    else
      total_weight = line_items.map{ |li| li.variant.weight.to_f * li.quantity.to_f }.sum.to_f
      total_weight += 1.8 # Stat flat mailer rate
    end
    total_weight
  end
end
