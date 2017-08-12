module ProductPriceRangeHelper
  def product_price_range(product)
    price = number_to_currency(product.min_price, strip_insignificant_zeros: true)
    price =  "#{price} - #{number_to_currency(product.max_price)}" unless product.min_price == product.max_price
    price
  end
end
