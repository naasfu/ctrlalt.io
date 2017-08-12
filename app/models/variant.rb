class Variant < ActiveRecord::Base
  belongs_to :product, touch: true
  has_one :group_buy, through: :product

  validates :name, :weight, :unit_price, presence: true
  validates_numericality_of :weight, greater_than_or_equal_to: 0.00
  validates_numericality_of :stock, greater_than_or_equal_to: 0, allow_blank: true
  validates_numericality_of :unit_price, greater_than_or_equal_to: 0.00, less_than: 2500

  scope :on_sale, -> { where.not(sale_price: :nil) }
  scope :sorted, -> { order(position: :asc) }
  scope :visible, -> { where(visible: true) }
  scope :active, -> { where(active: true) }
  scope :sort_by_lowest_price, -> { order(unit_price: :asc) }
  scope :sort_by_highest_price, -> { order(unit_price: :desc) }
  scope :sort_by_lowest_sale_price, -> { order(sale_price: :asc) }
  scope :sort_by_highest_sale_price, -> { order(sale_price: :desc) }


  def current_price
    sale_price || unit_price
  end

  def on_sale?
    !sale_price.blank?
  end

  def in_stock?
    stock.to_i > 0 || stock.blank?
  end

  def available?
    in_stock? && active?
  end

  def unavailable?
    !available?
  end

  def sold
    Order.paid.includes(:line_items).where(
      'line_items.variant_id' => self.id
    ).references(:line_items).sum(:quantity)
  end

  def sold_quantity
    Order.paid.includes(:line_items).where(
      'line_items.variant_id' => self.id
    ).references(:line_items).sum(:quantity)
  end

  def sold_total_amount
    sold_quantity * unit_price
  end
end
