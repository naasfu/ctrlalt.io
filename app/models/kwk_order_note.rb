class KwkOrderNote < ActiveRecord::Base
  belongs_to :kwk_order
  belongs_to :user
  
  validates :content, presence: true

  scope :newest, -> { order(created_at: :desc) }
end
