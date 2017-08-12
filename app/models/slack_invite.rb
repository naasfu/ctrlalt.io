class SlackInvite < ActiveRecord::Base
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: /@/
  validates :username, presence: true, uniqueness: { case_sensitive: false }

  scope :uninvited, -> { where(invited: false) }
  scope :invited,   -> { where(invited: true) }
  scope :newest,    -> { order(created_at: :desc) }
end
