class GeocodeShippingAddress
  def self.call(shipping_address)
    geo = Geokit::Geocoders::GoogleGeocoder.geocode("#{shipping_address.street1}, #{shipping_address.city} #{shipping_address.state || shipping_address.zip}")
    if geo.success?
      shipping_address.latitude  = geo.lat
      shipping_address.longitude = geo.lng
      shipping_address.save
    end
  end
end