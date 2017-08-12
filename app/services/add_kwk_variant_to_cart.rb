class AddKwkVariantToCart
  def self.call(variant_id, cart)
    variant = KwkVariant.includes(:kwk_sale).find(variant_id)

    if variant.present?
      add_to_cart(variant, cart)
    else
      raise 'Please select an option to add this bro to your kart.'
    end
  end

private

  def self.add_to_cart(variant, cart)
    raise 'This kap is unavailable.' if variant.kwk_sale.past_deadline?

    line_item = cart.line_items.find_by(kwk_variant_id: variant.id)

    if variant.active?
      if line_item
        raise 'This kap is already in your kart!'
      else
        line_item = cart.line_items.create(
          variant:       variant,
          unit_price:    variant.unit_price,
          kwk_sale_name: variant.kwk_sale.name,
          product_name:  variant.product.name,
          variant_name:  variant.name,
          image_url:     variant.product.image_url(:md)
        )
        line_item.move_to_bottom
      end
    else
      line_item.destroy if line_item
      raise 'This kap is unavailable.'
    end
  end
end