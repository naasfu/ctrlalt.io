class Address < ApplicationRecord
  include Easypostable
  
  validates_presence_of :street1, :city, :state, :zip, :country

  scope :newest,   -> { order(created_at: :desc) }
end
