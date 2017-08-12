class ShippingAddress < Address

  validates_presence_of :full_name

  def verified_address?
    # USPS can only verify US addresses.
    if country == 'US'
      @verifed_address ||= EasyPost::Address.create_and_verify(
        name:    full_name,
        street1: street1,
        street2: street2,
        city:    city,
        state:   state,
        zip:     zip,
        country: country,
        phone:   phone
      )
      return true
    else
      return true
    end
  rescue EasyPost::Error => e
    return false
  end

end
