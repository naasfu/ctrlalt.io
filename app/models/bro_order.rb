class BroOrder < ActiveRecord::Base
  PAYPAL_CERT_PEM = File.read("#{Rails.root}/certs/paypal/paypal_cert.pem")
  APP_CERT_PEM    = File.read("#{Rails.root}/certs/paypal/app_cert.pem")
  APP_KEY_PEM     = File.read("#{Rails.root}/certs/paypal/app_key.pem")

  include HasGuid
  include Easypostable
  include Workflow

  has_many :fulfillments, class_name: 'BroFulfillment'
  has_many :line_items, class_name: 'BroLineItem'
  has_many :notes, class_name: 'BroOrderNote'
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
      event :transaction_successful, transition_to: :paid
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

  def paypal_encrypted(return_url, notify_url)
    values = {
      :business => ENV['paypal_email'],
      :cmd => '_cart',
      :charset => 'UTF-8',
      :currency_code => 'USD',
      :upload => 1,
      :return => return_url,
      :invoice => guid,
      :notify_url => notify_url,
      :cert_id => ENV['paypal_cert_id'],
      :image_url => 'https://ctrlalt.io/logo_paypal.jpg'
    }

    paypal_item_index = 1

    line_items.approved.each do |li|
      values.merge!({
        "amount_#{paypal_item_index}" => li.unit_price.to_s,
        "item_name_#{paypal_item_index}" => "#{li.product_name} (#{li.bro_sale_name}) in #{li.variant_name}",
        "quantity_#{paypal_item_index}" => 1
      })
      paypal_item_index += 1
    end

    values.merge!({
      "amount_#{paypal_item_index}" => shipping_total,
      "item_name_#{paypal_item_index}" => "Shipping",

      "amount_#{paypal_item_index+1}" => donation_amount,
      "item_name_#{paypal_item_index+1}" => "Donation",

      "amount_#{paypal_item_index+2}" => fee_total,
      "item_name_#{paypal_item_index+2}" => "Handling"
    })

    encrypt_for_paypal(values)
  end

  def encrypt_for_paypal(values)
    signed = OpenSSL::PKCS7::sign(OpenSSL::X509::Certificate.new(APP_CERT_PEM), OpenSSL::PKey::RSA.new(APP_KEY_PEM, ''), values.map { |k, v| "#{k}=#{v}" }.join("\n"), [], OpenSSL::PKCS7::BINARY)
    OpenSSL::PKCS7::encrypt([OpenSSL::X509::Certificate.new(PAYPAL_CERT_PEM)], signed.to_der, OpenSSL::Cipher::Cipher::new("DES3"), OpenSSL::PKCS7::BINARY).to_s.gsub("\n", "")
  end

  def is_winner?
    %w[winner paid shipping fulfilled].include? workflow_state
  end

  def bro_sales
    @bro_sales ||= products.includes(:bro_sale).map(&:bro_sale).uniq
  end

  def shipping_total
    @shipping_total ||= if shipping_amount
      shipping_amount
    else
      if shipping_address.present? && shipping_address.country == 'US'
        8.00
      else
        13.00
      end
    end
  end

  def line_items_total
    @line_items_total ||= line_items.approved.any? ? line_items.approved.to_a.sum(&:unit_price) : 0.0
  end

  def fee_total
    @fee_total ||= (line_items_total * 0.05) + 0.50
  end

  def donation_total
    @donation_total ||= donation_amount.to_f
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
    BroOrderMailer.approved(self).deliver_later
  end
end
