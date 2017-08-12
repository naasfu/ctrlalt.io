class KwkSale < ActiveRecord::Base

  # Concerns
  include HasSlug

  # Images
  mount_uploader :banner, BasicUploader
  mount_uploader :logo, BasicUploader

  # Relationships
  has_many :products, class_name: 'KwkProduct'
  has_many :sorted_products, -> { active.visible.sorted }, class_name: 'KwkProduct'

  # Validations
  validates :name, :slug, :deadline, presence: true

  # Scopes
  scope :by_deadline, -> { order(deadline: :desc) }
  scope :visible,     -> { where(visible: true)   }
  scope :active,      -> { where(active: true)    }
  scope :ongoing,     -> { where(['deadline >= ?', Time.zone.now]).active.visible.by_deadline }
  scope :archived,    -> { where(['deadline <= ?', Time.zone.now]).active.visible.by_deadline }

  def orders
    KwkOrder.joins(:line_items).where(
      'kwk_line_items.kwk_variant_id' => self.products.map { |product| product.variants.map(&:id).flatten }
    ).uniq
  end

  def ongoing?
    deadline >= Time.zone.now ? true : false
  end

  def past_deadline?
    !ongoing?
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

end
