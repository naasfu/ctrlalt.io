module BroOrderSearch
  extend ActiveSupport::Concern

private

  def search_orders(params, searchable)
    results = searchable

    if params[:workflow_state].present?
      results = results.where(workflow_state: params[:workflow_state])
    end

    if params[:location].present?
      results = results.includes(:shipping_address)

      results = if params[:location] == 'CONUS'
        results.where('addresses.country' => 'US')
      else
        results.where.not('addresses.country' => 'US')
      end

      results = results.references(:shipping_address)
    end

    if params[:keyword].present?
      results = results.includes(:shipping_address).where(
        order_search_query({
          bro_orders: ['guid', 'email', 'geekhack_username', 'ip_address'],
          addresses: ['full_name', 'street1', 'street2', 'city', 'state', 'zip', 'phone', 'country']
        }),
        search: "%#{params[:keyword]}%"
      ).references(:shipping_address)
    end

    if params[:product_id].present?
      @found_product = BroProduct.find_by(id: params[:product_id])
      if @found_product
        results = results.where(
          'bro_line_items.bro_variant_id' => @found_product.variants.map(&:id)
        )
      end
    end

    if params[:variant_id].present?
      @found_variant = BroVariant.find_by(id: params[:variant_id])
      if @found_variant
        results = results.joins(:line_items).where(
          'bro_line_items.bro_variant_id' => @found_variant.id
        )
      end
    end

    results.uniq
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