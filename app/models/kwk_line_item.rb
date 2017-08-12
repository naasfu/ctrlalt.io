class KwkLineItem < ActiveRecord::Base

  belongs_to :kwk_order, touch: true
  belongs_to :variant, class_name: 'KwkVariant', foreign_key: 'kwk_variant_id', touch: true

  has_one :product, through: :variant
  has_one :kwk_sale, through: :product

  acts_as_list scope: :kwk_order

  scope :approved, -> { where(approved: true) }
  scope :sorted,   -> { order(position: :asc) }

  def quantity
    1
  end

end
