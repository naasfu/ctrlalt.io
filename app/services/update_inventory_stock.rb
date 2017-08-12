class UpdateInventoryStock
  def self.call(order)
    order.line_items.each do |li|
      variant = li.variant
      
      unless variant.stock.blank?
        variant.stock -= li.quantity
        variant.save
      end
    end
  end
end