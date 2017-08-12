class Faq < ActiveRecord::Base
  include HasSlug

  belongs_to :category, class_name: 'FaqCategory', foreign_key: 'faq_category_id'

  validates :q, :a, presence: true

  scope :sorted,  -> { order(position: :asc) }
  scope :visible, -> { where(visible: true) }
  scope :active,  -> { where(active: true) }
  scope :popular, -> { visible.active.sorted }

private
  

  def format_slug
    self.slug = slug.blank? ? q.parameterize : slug.parameterize
  end

end
