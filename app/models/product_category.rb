class ProductCategory < ActiveRecord::Base
  include HasSlug

  has_many :products

  validates :name, :slug, presence: true, uniqueness: true

  scope :sorted,  -> { order(position: :asc) }
  scope :visible, -> { where(visible: true) }
  scope :active,  -> { where(active: true) }
end
