class Carousel < ActiveRecord::Base
  mount_uploader :file, BasicUploader

  scope :sorted, -> { order(position: :asc) }
end
