class EasypostSelectPresenter
  include ActionView::Helpers::NumberHelper

  def initialize(fulfillable, include_fees = true)
    @fulfillable      = fulfillable
    @shipping_address = @fulfillable.shipping_address
    @include_fees     = include_fees
  end

  def radio_options
    if @shipping_address.present? && @shipping_address.valid? && @fulfillable.shipment && @fulfillable.shipment.rates.any? 

      @fulfillable.shipment.rates.sort_by { |rate| rate['rate'].to_f }.map do |rate|
        service_cost  = rate['rate'].to_f
        service_cost += @fulfillable.handling_fee_amount if @include_fees
        [
          "<strong>#{format_service_name(rate['service'])}</strong><br><span class='price'>+#{number_to_currency(service_cost)}</span>".html_safe, 
          rate['id']
        ]
      end
      
    else
      []
    end
  end

private

  def format_service_name(service_name)
    case service_name
    when "First"
      if @fulfillable.all_items_are_flat?
        "Sticker Mailer (No tracking) (3-7 days*)"
      else
        "First (3-5 days*)"
      end
    when "Priority"
      "Priority (2-3 days*)"
    when "Express"
      "Express (2-3 days*)"
    when "ParcelSelect"
      "Parcel Select (5-7 days*)"
    when "FirstClassMailInternational"
      "First Class International (7-9 days*)"
    when "FirstClassPackageInternationalService"
      "First Class International Service (7-9 days*)"
    when "PriorityMailInternational"
      "Priority International (7-9 days*)"
    when "ExpressMailInternational"
      "Express International (5-7 days*)"
    else
      service_name
    end
  end

end