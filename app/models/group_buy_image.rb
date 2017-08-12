class GroupBuyImage < ActiveRecord::Base
  belongs_to :group_buy, touch: true
  mount_uploader :file, BasicUploader
  
  scope :sorted,  -> { order(position: :asc) }
end
