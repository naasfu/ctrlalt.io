class LineItem < ActiveRecord::Base
  belongs_to :order, touch: true
  belongs_to :variant, touch: true

  has_one :product, through: :variant
  has_one :group_buy, through: :product

  def image_url(size)
    product.image_url(size)
  end

  def total_amount
    unit_price.to_f * quantity.to_f
  end
end
