class Comment < ActiveRecord::Base
  belongs_to :support_request
  belongs_to :user

  validates :content, presence: true

  scope :newest, -> { order(created_at: :desc) }
  scope :oldest, -> { order(created_at: :asc) }
end
