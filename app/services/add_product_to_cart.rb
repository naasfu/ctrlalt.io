class AddProductToCart
  def initialize(variant, quantity, cart)
    @variant  = variant
    @product  = variant.product
    @quantity = quantity.to_i > 0 ? quantity.to_i : 1
    @cart     = cart
  end

  def add
    if line_item
      # Already in cart
      line_item.update_attribute(:quantity, line_item.quantity += @quantity)
    else
      # Add product to cart
      @cart.line_items.create(
        variant:        @variant, 
        quantity:       @quantity, 
        unit_price:     @variant.current_price.to_f, 
        group_buy_name: @variant.group_buy.name, 
        product_name:   @variant.product.name, 
        variant_name:   @variant.name,
        is_flat:        @variant.is_flat
      )
    end
    line_item
  end

  def out_of_stock?
    @variant.stock.present? && @variant.stock.to_i <= 0
  end

  def quantity_over_stock?
    if line_item
      @variant.stock.present? && (line_item.quantity + @quantity) > @variant.stock
    else
      @variant.stock.present? && @quantity > @variant.stock
    end
  end

  def quantity_over_limit?
    if line_item
      @variant.limit.present? && (line_item.quantity + @quantity) > @variant.limit
    else
      @variant.limit.present? && @quantity > @variant.limit
    end
  end

  def unavailable?
    !@product.active? && !@variant.active?
  end

private

  def line_item
    @line_item ||= @cart.line_items.find_by(variant: @variant)
  end
end