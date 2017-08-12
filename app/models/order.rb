class Order < ActiveRecord::Base
  include HasGuid
  include Easypostable
  include Workflow

  has_many :fulfillments
  has_many :line_items
  has_many :notes
  has_many :tracking_notes
  has_many :transactions
  has_many :products, through: :line_items
  has_many :variants, through: :line_items

  belongs_to :card, required: false
  belongs_to :user, required: false
  belongs_to :shipping_address, required: false
  belongs_to :billing_address, required: false

  validates :donation_amount,
    allow_blank: false,
    numericality: { greater_than_or_equal_to: 0 }

  validates :email, presence: true, allow_blank: true, format: /@/

  scope :carts,          -> { where(workflow_state: 'incomplete') }
  scope :paid,           -> { where(workflow_state: ['paid', 'shipping', 'fulfilled']) }
  scope :not_incomplete, -> { where.not(workflow_state: ['incomplete', 'canceled']) }
  scope :by_placed_at,   -> { order(placed_at: :desc) }
  scope :sorted,         -> { not_incomplete.by_placed_at }

  workflow do
    state :incomplete do
      event :payment_successful, transition_to: :paid
    end

    state :paid do
      event :ship, transition_to: :shipped
      event :cancel, transition_to: :canceled
    end

    state :canceled do
      event :uncancel, transition_to: :paid
    end

    state :refunding_transaction
    state :refunded

    state :shipped
    state :delivered
  end

  def ship
    OrderMailer.shipped(self).deliver_later
  end

  def charge
    @charge ||= Stripe::Charge.retrieve(self.charge_id)
  end

  def line_items_count
    line_items.sum(:quantity)
  end

  def shipping_total
    @shipping_total ||= if shipping_amount
      shipping_amount
    elsif rate_id && shipping_address.present?
      shipment_cost
    else
      0.00
    end
  end

  def line_items_total
    @line_items_total ||= if line_items_amount
      line_items_amount
    else
      line_items.any? ? line_items.to_a.sum { |li| li.unit_price * li.quantity } : 0.0
    end
  end

  def fee_total
    @fee_total ||= if fee_amount
      fee_amount
    else
      ((line_items_total + shipping_total) * 0.05) + 0.50
    end
  end

  def donation_total
    @donation_total ||= donation_amount
  end

  def grand_total
    grand_total = line_items_total + fee_total + donation_total + shipping_total
    @grand_total ||= grand_total
  end

  def grand_total_in_cents
    @grand_total_in_cents ||= (grand_total.to_f * 100.0).to_i
  end

  def donated?
    donation_total > 0
  end

  def is_empty?
    line_items.empty?
  end

  def total_weight_in_oz
    total_weight = line_items.map{ |li| li.variant.weight.to_f * li.quantity.to_f }.sum.to_f
    total_weight += total_weight * 0.25
    total_weight
  end

  def is_ready_for_purchase?
    return false if shipping_address.blank?
    return false if card.blank?
    return false if rate_id.blank?
    true
  end
end
