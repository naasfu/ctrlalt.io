class Card < ActiveRecord::Base
  belongs_to :user

  def source
    customer ||= Stripe::Customer.retrieve(user.stripe_customer_id)
    @source ||= customer.sources.all.data.select{ |c| c.fingerprint == fingerprint }.last
  end

  def name
    source.name
  end

  def brand
    source.brand
  end

  def last4
    source.last4
  end

  def address_line1
    source.address_line1
  end

  def address_line2
    source.address_line2
  end

  def address_city
    source.address_city
  end

  def address_state
    source.address_state
  end

  def address_zip
    source.address_zip
  end

  def address_country
    source.address_country
  end

  CardAddress = Struct.new(:street1, :street2, :city, :state, :zip, :country)

  def billing_address
    @billing_address = CardAddress.new(address_line1, address_line2, address_city, address_state, address_zip, address_country)
  end

  def billing_address?
    true if source.address_line1 && source.address_zip
  end

  def incomplete_billing_address?
    return true if address_line1.blank?
    return true if address_city.blank?
    return true if address_state.blank?
    return true if address_zip.blank?
    return true if address_country.blank?
    return false
  end

  def no_billing_address?
    if address_line1.blank? &&
    address_line2.blank? &&
    address_city.blank? &&
    address_state.blank? &&
    address_zip.blank? &&
    address_country.blank?
      true
    else
      false
    end
  end
end
