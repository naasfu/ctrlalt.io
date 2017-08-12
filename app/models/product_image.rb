class ProductImage < ActiveRecord::Base
  belongs_to :product, touch: true
  has_one :group_buy, through: :product
  
  mount_uploader :file, BasicUploader
  
  scope :sorted,  -> { order(position: :asc) }
end
