class Newsletter < ActiveRecord::Base

  include HasSlug

  belongs_to :group_buy

  validates :subject, :slug, :content, presence: true

  scope :has_been_sent, -> { where.not(last_sent_at: nil) }
  scope :newest, -> { order(created_at: :desc) }
  scope :oldest, -> { order(created_at: :asc) }

  def recipients
    @recipients ||= if group_buy.present?
      group_buy.orders.not_incomplete.map(&:user)
    else
      User.newsletter_subscribers
    end
  end

private

  def format_slug
    self.slug = slug.blank? ? subject.parameterize : slug.parameterize
  end

end
