class Product < ActiveRecord::Base
  include HasSlug
  mount_uploader :image, BasicUploader

  belongs_to :group_buy, touch: true
  belongs_to :category, class_name: 'ProductCategory', foreign_key: 'product_category_id'
  has_many :variants
  has_many :images, class_name: 'ProductImage'

  validates :name, :slug, presence: true
  validates :slug, uniqueness: { case_sensitive: false }

  scope :purchaseable, -> { active.visible }
  scope :sorted, -> { order(position: :asc) }
  scope :visible, -> { where(visible: true) }
  scope :active, -> { where(active: true) }

  has_many :sorted_variants, -> { active.visible.sorted }, class_name: "Variant"
  has_many :sorted_images, -> { sorted }, class_name: "ProductImage"

  def current_variants
    variants.active.visible.sorted
  end

  def master_variant
    @master_variant ||= current_variants.first
  end

  def min_price
    current_variants.map { |v| v.current_price }.min
  end

  def max_price
    current_variants.map { |v| v.current_price }.max
  end

  def expired?
    group_buy.deadline <= Time.zone.now
  end
  
  def available?
    return false if current_variants.blank?
    return false if expired? && group_buy.name != 'Store'
    return true
  end
  
  def out_of_stock?
    @out_of_stock ||= current_variants.where.not(stock: nil).map { |v| v.stock.to_i == 0 }.all?
  end
end
