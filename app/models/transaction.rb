class Transaction < ApplicationRecord
  include HasGuid

  belongs_to :order

  scope :newest, -> { order(created_at: :desc) }
end
