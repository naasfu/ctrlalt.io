class FaqCategory < ActiveRecord::Base
  include HasSlug

  has_many :faqs
  has_many :sorted_faqs, -> { popular }, class_name: "Faq"

  validates :name, presence: true

  scope :sorted,  -> { order(position: :asc) }
  scope :visible, -> { where(visible: true) }
  scope :active,  -> { where(active: true) }
  scope :popular, -> { visible.active.sorted }
end
