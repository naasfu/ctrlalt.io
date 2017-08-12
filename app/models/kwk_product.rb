class KwkProduct < ActiveRecord::Base

  include HasSlug
  mount_uploader :image, BasicUploader
  mount_uploader :thumbnail, BasicUploader

  belongs_to :kwk_sale, touch: true
  has_many :variants, class_name: 'KwkVariant'
  has_many :sorted_variants, -> { active.visible.sorted }, class_name: 'KwkVariant'

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
    kwk_sale.deadline <= Time.zone.now
  end
  
  def available?
    current_variants.any? && !expired?
  end

end
