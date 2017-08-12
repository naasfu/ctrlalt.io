class AddBroVariantToCart
  def self.call(variant_id, cart)
    variant = BroVariant.includes(:bro_sale).find(variant_id)

    if variant.present?
      add_to_cart(variant, cart)
    else
      raise 'Please select an option to add this bro to your cart.'
    end
  end

private

  def self.add_to_cart(variant, cart)
    raise 'This bro is unavailable.' if variant.bro_sale.past_deadline?

    line_item = cart.line_items.find_by(bro_variant_id: variant.id)

    if variant.active?
      if line_item
        raise 'This bro is already in your cart!'
      else
        line_item = cart.line_items.create(
          variant:       variant,
          unit_price:    variant.unit_price,
          bro_sale_name: variant.bro_sale.name,
          product_name:  variant.product.name,
          variant_name:  variant.name
        )
        line_item.move_to_bottom
      end
    else
      line_item.destroy if line_item
      raise 'This bro is unavailable.'
    end
  end
end