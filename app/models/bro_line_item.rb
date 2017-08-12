class BroLineItem < ActiveRecord::Base
  belongs_to :bro_order, touch: true
  belongs_to :variant, class_name: 'BroVariant', foreign_key: 'bro_variant_id', touch: true

  has_one :product, through: :variant
  has_one :bro_sale, through: :product

  validates :tru_bro_id, presence: false, allow_blank: true, uniqueness: { case_sensitive: false }

  acts_as_list scope: :bro_order

  scope :approved, -> { where(approved: true) }
  scope :sorted,   -> { order(position: :asc) }

  def image_url(size)
    product.image_url(size)
  end

  def quantity
    1
  end

end
