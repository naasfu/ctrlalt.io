class GroupBuy < ActiveRecord::Base
  include HasSlug
  mount_uploader :image, BasicUploader

  has_many :products
  has_many :microposts
  has_many :colors
  has_many :images, class_name: 'GroupBuyImage'

  validates :name, :slug, :deadline, presence: true

  scope :by_deadline, -> { order(deadline: :desc) }
  scope :visible, -> { where(visible: true) }
  scope :active, -> { where(active: true) }
  scope :ongoing, -> { where(['deadline >= ?', Time.zone.now]).active.visible.by_deadline }
  scope :archived, -> { where(['deadline <= ?', Time.zone.now]).active.visible.by_deadline }

  has_many :sorted_products, -> { active.visible.sorted }, class_name: "Product"


  def orders
    Order.joins(:line_items).where(
      'line_items.variant_id' => self.products.map { |product| product.variants.map(&:id) }
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
    @ongoing ||= deadline >= Time.zone.now ? true : false
  end

  def shipping_tbd?
    # Shipping is TBD unless future date is set
    shipping_eta <= deadline ? true : false
  end

  def past_deadline?
    !ongoing?
  end
end
