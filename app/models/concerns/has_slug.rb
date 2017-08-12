module HasSlug
  extend ActiveSupport::Concern

  included do
    before_validation :format_slug
  end

  def to_param
    slug
  end

  def format_slug
    self.slug = slug.blank? ? name.parameterize : slug.parameterize
  end
end