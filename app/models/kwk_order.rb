class KwkOrder < ActiveRecord::Base
  include Paypalable
  include HasGuid
  include Workflow

  has_many :fulfillments, class_name: 'KwkFulfillment'
  has_many :line_items, class_name: 'KwkLineItem'
  has_many :notes, class_name: 'KwkOrderNote'
  has_many :products, through: :line_items
  has_many :variants, through: :line_items

  belongs_to :user
  belongs_to :shipping_address

  scope :carts,           -> { where(workflow_state: 'incomplete') }
  scope :paid,            -> { where(workflow_state: ['paid', 'shipping', 'fulfilled']) }
  scope :winners,         -> { where(workflow_state: ['winner', 'paid', 'shipping', 'fulfilled']) }
  scope :not_incomplete_or_canceled, -> { where.not(workflow_state: ['incomplete', 'canceled']) }
  scope :not_incomplete,  -> { where.not(workflow_state: ['incomplete']) }
  scope :by_placed_at,    -> { order(placed_at: :desc) }
  scope :by_submitted_at, -> { order(submitted_at: :desc) }
  scope :sorted,          -> { not_incomplete.by_submitted_at }

  workflow do
    state :incomplete do
      event :cancel, transition_to: :canceled
      event :submit, transition_to: :submitted
    end
    state :submitted do
      event :approve, transition_to: :winner
      event :disqualify, transition_to: :disqualified
    end
    state :winner do
      event :process_transaction, transition_to: :processing_transaction
      event :pay, transition_to: :paid
      event :cancel, transition_to: :canceled
    end
    state :invalid_details do
      event :ship, transition_to: :shipping
      event :cancel, transition_to: :canceled
    end
    state :processing_transaction do
      event :transaction_successful, transition_to: :paid
      event :transaction_failed,     transition_to: :payment_failed
      event :cancel,                 transition_to: :canceled
    end
    state :payment_failed do
      event :transaction_successful, transition_to: :paid
      event :process_transaction,    transition_to: :processing_transaction
      event :cancel,                 transition_to: :canceled
      event :revert,                 transition_to: :winner
    end
    state :paid do
      event :ship, transition_to: :shipping
      event :cancel, transition_to: :canceled
      event :shipment_failed, transition_to: :invalid_details
    end
    state :shipping do
      event :delivered, transition_to: :fulfilled
    end
    state :fulfilled 
    state :disqualified 
    state :canceled
  end

  def has_kap?(variant)
    line_items.find_by(kwk_variant_id: variant.id)
  end

  def is_winner?
    %w[winner paid shipping fulfilled].include? workflow_state
  end

  def kwk_sales
    @kwk_sales ||= products.includes(:kwk_sale).map(&:kwk_sale).uniq
  end

  def shipping_total
    @shipping_total ||= 18.00
  end

  def line_items_total
    @line_items_total ||= line_items.approved.any? ? line_items.approved.to_a.sum(&:unit_price) : 0.0
  end

  def fee_total
    @fee_total ||= (line_items_total * 0.05) + 0.50
  end

  def donation_total
    @donation_total ||= donation_amount
  end

  def grand_total
    grand_total = line_items_total + fee_total + donation_total + shipping_total
    @grand_total ||= grand_total
  end

  def grand_total_in_cents
    @grand_total_in_cents ||= (grand_total * 100.0).to_i
  end

  def donated?
    donation_total > 0
  end

  def is_empty?
    line_items.empty?
  end

  def winnings
    @winnings ||= line_items.approved.sorted
  end

  # Workflow transistions
  def submit
  end

  def approve
    update_attribute(:approved_at, Time.zone.now)
    KwkOrderMailer.approved(self).deliver_later
  end
end
