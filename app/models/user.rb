class User < ActiveRecord::Base
  before_save :downcase_email
  before_create :generate_confirmation_token
  before_create :generate_unsubscribe_token
  before_validation :format_username

  has_secure_password

  attr_accessor :subscribe_to_newsletter

  mount_uploader :avatar, AvatarUploader
  
  has_many :addresses
  has_many :shipping_addresses
  has_many :billing_addresses
  has_many :cards
  
  has_many :support_requests
  has_many :group_buys
  has_many :orders
  has_many :kwk_orders
  has_many :bro_orders
  has_many :carts, -> { where(workflow_state: 'incomplete') }, class_name: 'Order'

  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: /@/
  # validates :username, presence: true, uniqueness: true,
  #   exclusion:  %w[new edit index session login logout users admin stylesheets assets javascripts images]

  scope :newest,                 -> { order(created_at: :desc) }
  scope :newsletter_subscribers, -> { where(all_newsletters: true) }

  def to_param
    username
  end

private

  def generate_confirmation_token
    self.confirmation_token = SecureRandom.uuid()
  end
  
  def generate_unsubscribe_token
    self.unsubscribe_token = SecureRandom.uuid()
  end

  def format_username
    if self.username.present?
      self.username = username.parameterize 
    else
      self.username = self.id
    end
  end

  def downcase_email
    self.email.downcase! if self.email.present?
  end
end
