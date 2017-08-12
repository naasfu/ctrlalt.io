class BroProduct < ActiveRecord::Base
  include HasSlug
  mount_uploader :image, BasicUploader
  mount_uploader :thumbnail, BasicUploader
  mount_uploader :banner, BasicUploader

  belongs_to :bro_sale, touch: true
  has_many :variants, class_name: 'BroVariant'
  has_many :images, class_name: 'BroProductImage'

  validates :name, :slug, presence: true
  validates :slug, uniqueness: { case_sensitive: false }

  scope :sorted, -> { order(position: :asc) }
  scope :visible, -> { where(visible: true) }
  scope :active, -> { where(active: true) }

  def current_variants
    variants.active.visible.sorted
  end

  def master_variant
    current_variants.first
  end

  def min_price
    current_variants.map { |v| v.unit_price }.min
  end

  def max_price
    current_variants.map { |v| v.unit_price }.max
  end

  def expired?
    bro_sale.deadline <= Time.zone.now
  end
  
  def available?
    current_variants.any? && !expired?
  end
end
