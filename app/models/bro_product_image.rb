class BroProductImage < ActiveRecord::Base
  belongs_to :product, class_name: 'BroProduct', foreign_key: 'bro_product_id', touch: true
  has_one :bro_sale, through: :product
  
  mount_uploader :file, BasicUploader
  mount_uploader :thumbnail, BasicUploader
  
  scope :sorted,  -> { order(position: :asc) }
end
