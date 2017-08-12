class BillingAddress < Address
  validates_presence_of :street1, :city, :state, :zip, :country
end
