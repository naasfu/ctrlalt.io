module BroEasypostable
  extend ActiveSupport::Concern

  def from_address
    @from_address ||= EasyPost::Address.create(
      company: "Bro Caps",
      street1: "PO Box 92423",
      city:    "Henderson",
      state:   "NV",
      zip:     "89009",
      phone:   "408-580-4841"
    )
  end

  def to_address
    @to_address ||= EasyPost::Address.create( 
      name:     "#{shipping_address.full_name} (#{bro_order.geekhack_username})",
      street1:  shipping_address.street1,
      street2:  shipping_address.street2,
      city:     shipping_address.city,
      state:    shipping_address.state,
      country:  shipping_address.country,
      zip:      shipping_address.zip,
    )
  end

  def customs_items
    @customs_items ||= line_items.map do |line_item|
      EasyPost::CustomsItem.create(
        description:    line_item.product_name,
        quantity:       1,
        value:          5.00,
        weight:         line_item.variant.weight,
        origin_country: 'US'
      )
    end
  end

  def customs_info
    @customs_info ||= EasyPost::CustomsInfo.create(
      contents_type:    'merchandise',
      restriction_type: 'none',
      customs_items:    customs_items
    )
  end

  def row_box
    {
      length:             9,
      width:              6.5,
      height:             2.8,
      weight:             total_weight_in_oz
    }
  end

  def small_flate_rate
    {
      predefined_package: 'SmallFlatRateBox',
      weight:             total_weight_in_oz
    }
  end

  def parcel
    @parcel ||= EasyPost::Parcel.create(shipping_address.country == 'US' ? small_flate_rate : row_box)
  end

  def shipment
    @shipment ||= if try(:shipment_id )
      EasyPost::Shipment.retrieve(shipment_id)
    else
      EasyPost::Shipment.create(
        to_address:   to_address,
        from_address: from_address,
        parcel:       parcel,
        customs_info: customs_info
      )
    end
  end

  def current_rate
    @current_rate ||= shipment.lowest_rate.rate.to_i
  end

  # Returns the rate object if a label was purchased.
  def purchased_rate
    @purchased_rate ||= shipment.selected_rate
  end

  # Returns an absolute url of the shipping label in .png format.
  def label_png_url
    @label_png_url ||= shipment.postage_label.label_url
  end

  def label_zpl_url
    @label_zpl_url ||= (shipment.postage_label.label_zpl_url || shipment.label(file_format: :zpl).postage_label.label_zpl_url)
  end

  def shipment_service_name
    @shipment_service_name ||= purchased_rate ? purchased_rate.service.underscore.humanize : 'N/A'
  end

  def shipment_cost
    @shipment_cost ||= purchased_rate ? purchased_rate.rate.to_i : 0
  end

  def tracking_code
    @tracking_code ||= shipment.tracking_code || tracking_number
  end
  
  def total_weight_in_oz
    8.00
  end
  
  # Check if shipping address is present and/or valid.
  def invalid_shipping_address?
    shipping_address.blank? || !shipping_address.valid?
  end

  def handling_fee_amount
    0.50
  end
end