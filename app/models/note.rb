class Note < ActiveRecord::Base
  belongs_to :order
  belongs_to :user
  
  validates :content, presence: true

  scope :newest, -> { order(created_at: :desc) }
end
