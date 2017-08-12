class Inquiry < ActiveRecord::Base
  after_create :send_received_email

  include HasGuid

  belongs_to :user
  
  validates :content, :subject, presence: true
  validates :email,   presence: true, format: /@/

  scope :newest, -> { order(created_at: :desc) }

private

  def send_received_email
    InquiryMailer.received(self).deliver_later
  end
end
