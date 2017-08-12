class BroSaleImage < ActiveRecord::Base
  belongs_to :bro_sale, touch: true
  mount_uploader :file, BasicUploader
  
  scope :sorted,  -> { order(position: :asc) }
end
