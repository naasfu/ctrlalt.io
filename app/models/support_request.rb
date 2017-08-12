class SupportRequest < ActiveRecord::Base
  include HasGuid

  belongs_to :user
  belongs_to :order

  has_many :comments

  validates :content, presence: true

  scope :newest,   -> { order(created_at: :desc) }
  scope :with_closed_state, -> { where(workflow_state: ['closed', 'resolved', 'on_hold']) }

  include Workflow
  workflow do
    state :open do
      event :resolve, transition_to: :resolved
      event :close, transition_to: :closed
      event :hold, transition_to: :on_hold
    end
    state :on_hold do
      event :resolve, transition_to: :resolved
      event :close, transition_to: :closed
      event :resume, transition_to: :open
    end
    state :resolved do
      event :reopen, transition_to: :open
    end
    state :closed do
      event :reopen, transition_to: :open
    end
  end

  def resolve
    update_attribute(:resolved_at, Time.zone.now)
  end

  def close
    update_attribute(:closed_at, Time.zone.now)
  end

  def hold
    update_attribute(:on_hold_at, Time.zone.now)
  end

  def tag_list
    tag = Struct.new(:name, :support_request)
    tags.map { |name| tag.new(name, self) }
  end

  def last_reply
    @last_reply ||= comments.newest.first
  end
end
