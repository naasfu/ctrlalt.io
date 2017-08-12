class Micropost < ActiveRecord::Base
  belongs_to :user
  belongs_to :group_buy

  validates :content, presence: true

  scope :newest, -> { order(created_at: :desc) }
end
