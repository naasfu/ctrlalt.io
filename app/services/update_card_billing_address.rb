class UpdateCardBillingAddress
  def self.call(customer, order)
    billing_address = order.billing_address

    if billing_address
      sources = customer.sources.all.data.select do |source|
        source.fingerprint == order.card.fingerprint
      end

      card = sources.last

      card.address_line1   = billing_address.street1
      card.address_line2   = billing_address.street2 if billing_address.street2.present?
      card.address_city    = billing_address.city
      card.address_state   = billing_address.state
      card.address_zip     = billing_address.zip
      card.address_country = billing_address.country
      card.save
    end
  end
end