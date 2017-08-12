module Easypostable
  extend ActiveSupport::Concern

  def from_address
    @from_address ||= EasyPost::Address.create(
      company: '[CTRL]ALT',
      street1: ENV['return_street1'],
      street2: ENV['return_street2'],
      city:    ENV['return_city'],
      zip:     ENV['return_zip'],
      state:   ENV['return_state'],
      phone:   ENV['return_phone']
    )
  end

  def to_address
    @to_address ||= EasyPost::Address.create( 
      name:     shipping_address.full_name,
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
        quantity:       line_item.quantity,
        value:          line_item.unit_price,
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

  def parcel
    @parcel ||= EasyPost::Parcel.create( 
      predefined_package: predefined_package_type,
      weight:             total_weight_in_oz
    )
  end

  def new_shipment
    @new_shipment ||= EasyPost::Shipment.create(
      to_address:   to_address,
      from_address: from_address,
      parcel:       parcel,
      customs_info: customs_info
    )
  end

  def shipment
    @shipment ||= if shipment_id
      EasyPost::Shipment.retrieve(shipment_id)
    else
      new_shipment
    end
  end

  def shipment_rates
    @shipment_rates ||= shipment.rates.sort_by { |rate| rate['rate'].to_f }
  end

  def purchased_rate
    @purchased_rate ||= shipment.selected_rate
  end

  def label_url
    @label_url ||= shipment.postage_label.label_url
  end

  def label_zpl_url
    @label_zpl_url ||= (shipment.postage_label.label_zpl_url || shipment.label(file_format: :zpl).postage_label.label_zpl_url)
  end

  def shipment_service_name
    @shipment_service_name ||= purchased_rate ? purchased_rate.service.underscore.humanize : 'N/A'
  end

  def shipment_cost
    @shipment_cost ||= EasyPost::Rate.retrieve(rate_id).rate.to_f + handling_fee_amount
  end

  def tracking_code
    @tracking_code ||= shipment.tracking_code || tracking_number
  end
  
  def handling_fee_amount
    0.50
  end

  def predefined_package_type
    if all_items_are_flat?
      'Flat'
    else
      'Parcel'
    end
  end

  def all_items_are_flat?
    line_items.map(&:is_flat).all?
  end
end