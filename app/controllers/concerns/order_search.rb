module OrderSearch
  extend ActiveSupport::Concern

private

  def search_orders(params, group_buy=nil)
    results = if group_buy
      group_buy.orders.not_incomplete
    else
      Order.not_incomplete
    end

    if params[:workflow_state].present?
      results = results.where(workflow_state: params[:workflow_state])
    end

    if params[:keyword].present?
      results = results.includes(:shipping_address).where(
        order_search_query({
          orders: ['guid', 'email', 'geekhack_username', 'charge_id', 'ip_address', 'shipment_service'],
          shipping_addresses: ['full_name', 'street1', 'street2', 'city', 'state', 'zip', 'phone']
        }),
        search: "%#{params[:keyword]}%"
      ).references(:shipping_address)
    end

    if params[:product_id].present?
      @found_product = Product.find_by(id: params[:product_id])
      if @found_product
        results = results.where(
          'line_items.variant_id' => @found_product.variants.map(&:id)
        )
      end
    end

    if params[:variant_id].present?
      @found_variant = Variant.find_by(id: params[:variant_id])
      if @found_variant
        results = results.includes(:line_items).where(
          'line_items.variant_id' => @found_variant.id
        )
      end
    end

    results.by_placed_at.uniq
  end
  
  def order_search_query(options={})
    # k = table name containing attribute names
    # v = attributes array
    query = ''
    options.each do |k, v|
      v.each do |attribute|
        query += "#{k.to_s}.#{attribute} LIKE :search OR "
      end
    end
    query[0..-4] # Remove the appended ' OR '
  end
end