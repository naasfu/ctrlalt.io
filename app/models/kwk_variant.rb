class KwkVariant < ActiveRecord::Base
  belongs_to :product, class_name: 'KwkProduct', foreign_key: 'kwk_product_id', touch: true
  has_one :kwk_sale, through: :product

  validates :name, :weight, :unit_price, presence: true
  validates_numericality_of :weight, greater_than_or_equal_to: 0.00
  validates_numericality_of :unit_price, greater_than_or_equal_to: 0.00, less_than: 2500

  scope :on_sale, -> { where.not(sale_price: :nil) }
  scope :sorted,  -> { order(position: :asc) }
  scope :visible, -> { where(visible: true) }
  scope :active,  -> { where(active: true) }
  scope :sort_by_lowest_price,  -> { order(unit_price: :asc) }
  scope :sort_by_highest_price, -> { order(unit_price: :desc) }
  scope :sort_by_lowest_sale_price,  -> { order(sale_price: :asc) }
  scope :sort_by_highest_sale_price, -> { order(sale_price: :desc) }

  def submitted
    KwkOrder.not_incomplete_or_canceled.includes(:line_items).where(
      'kwk_line_items.kwk_variant_id' => self.id
    ).references(:line_items).count
  end

  def approved
    KwkOrder.not_incomplete_or_canceled.includes(:line_items).where(
      'kwk_line_items.kwk_variant_id' => self.id,
      'kwk_line_items.approved' => true
    ).references(:line_items).count
  end

  def submitted_total_amount
    submitted * unit_price
  end

  def approved_total_amount
    approved * unit_price
  end
end
