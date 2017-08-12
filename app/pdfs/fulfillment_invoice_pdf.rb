class FulfillmentInvoicePdf < Prawn::Document
  def initialize(fulfillment)
    super()
    @fulfillment      = fulfillment
    @order            = fulfillment.order
    @shipping_address = @order.shipping_address
    @billing_address  = @order.billing_address

    header

    define_grid(:columns => 6, :rows => 8, :gutter => 10)

    grid([0,2], [0,6]).bounding_box do
      move_down 15
      text "[CTRL]ALT", size: 16, style: :bold
      move_down 2
      text "Custom Keyboard & Desk Accessories"
      move_down 2
      text "https://ctrlalt.io", style: :italic
    end

    grid([1,0], [1,5]).bounding_box do
      text "Fulfillment invoice", style: :bold
      text "Thank you for your order! Below you can find your order and shipment details. Please contact us if you have any questions and have an awesome day!"
    end

    grid([2,0], [2,4]).bounding_box do
      move_up 30
      text "ORD##{@fulfillment.order.guid.upcase}", style: :bold
      move_down 5
      text @fulfillment.order.paid_at.strftime("Paid for %m/%d/%Y at %I:%M%p"), style: :italic
    end

    grid([2,3], [2,5]).bounding_box do
      move_up 30
      text "FUL##{@fulfillment.guid.upcase}", style: :bold
      move_down 5
      text Date.today.strftime("Printed on %m/%d/%Y at %I:%M%p"), style: :italic
    end

    grid([3,0], [3,4]).bounding_box do
      move_up 70
      text "Ship to", style: :bold
      move_down 5
      text @shipping_address.full_name
      text @shipping_address.street1
      text @shipping_address.street2 if @shipping_address.street2.present?
      text "#{@shipping_address.city} #{@shipping_address.state}, #{@shipping_address.zip}"
      text @shipping_address.country
    end

    grid([3,3], [3,5]).bounding_box do
      move_up 70
      text "Billing address", style: :bold
      move_down 5
      text @billing_address.street1
      text @billing_address.street2 if @billing_address.street2.present?
      text "#{@billing_address.city} #{@billing_address.state}, #{@billing_address.zip}"
      text @billing_address.country
    end

    move_up 45

    table line_item_rows, header: true, column_widths: [300, 120, 120] do
      row(0).style font_style: :bold
      column(0).style align: :left
      column(1).style align: :center
      column(2).style align: :center
    end

    table order_totals_rows, header: true, column_widths: [120, 120], position: :right do
      column(0).style align: :right, font_style: :bold
      column(1).style align: :left
    end

    move_down 20
    text footer_messages.sample, align: :center

  end

  def line_item_rows
    [["Name", "Price", "Quantity"]] +
    @fulfillment.line_items.map do |li|
      ["#{li.product_name} (#{li.group_buy_name})\n\u2014 #{li.variant_name}", number_to_currency(li.unit_price), li.quantity]
    end
  end

  def order_totals_rows
    [
      ["Shipping", number_to_currency(@order.shipping_total)],
      ["Subtotal", number_to_currency(@order.line_items_total)],
      ["Donation", number_to_currency(@order.donation_amount)],
      ["Total", number_to_currency(@order.grand_total)],
    ]
  end

  def header
    #This inserts an image in the pdf file and sets the size of the image
    move_down 13
    image "#{Rails.root}/app/assets/images/logo_invoice.png", height: 50
  end

  def number_to_currency(amount)
    ActionController::Base.helpers.number_to_currency(amount)
  end

  def footer_messages
    [
      "Be nice all the time.",
      "Homies help homies, always.",
      "We like you.",
      "Bad biscuits make the baker broke, bro.",
      "Responsibility demands sacrifice."
    ]
  end
end