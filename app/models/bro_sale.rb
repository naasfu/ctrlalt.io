class BroSale < ActiveRecord::Base
  include HasSlug
  mount_uploader :banner, BasicUploader
  mount_uploader :logo, BasicUploader

  has_many :colors
  has_many :products, class_name: 'BroProduct'
  has_many :images, class_name: 'BroSaleImage'

  validates :name, :slug, :deadline, presence: true

  scope :by_deadline, -> { order(deadline: :desc) }
  scope :visible, -> { where(visible: true) }
  scope :active, -> { where(active: true) }
  scope :ongoing, -> { where(['deadline >= ?', Time.zone.now]).active.visible.by_deadline }
  scope :archived, -> { where(['deadline <= ?', Time.zone.now]).active.visible.by_deadline }

  def orders
    BroOrder.joins(:line_items).where(
      'bro_line_items.bro_variant_id' => self.products.map { |product| product.variants.map(&:id).flatten }
    ).uniq
  end

  def days_left
    ongoing? ? (deadline.to_date - Time.zone.now.to_date).to_i : 0
  end

  def total_participants
    orders.includes(:user).paid.map(&:user).uniq.size
    # todo: map difference of nils for guest orders
  end

  def total_orders
    orders.paid.size
  end

  def grand_total
    orders.paid.to_a.sum(&:grand_total)
  end

  def ongoing?
    deadline >= Time.zone.now ? true : false
  end

  def shipping_tbd?
    # Shipping is TBD unless future date is set
    shipping_eta <= deadline ? true : false
  end

  def past_deadline?
    !ongoing?
  end
end
