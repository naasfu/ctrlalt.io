# Combine and cancel current 'paid' bro orders.

rng   = BroSale.find_by(slug: 'reapersngamers').orders.with_paid_state.map(&:user)
ns    = BroSale.find_by(slug: 'nightstalker').orders.with_paid_state.map(&:user)
users = rng + ns

users.compact.uniq.each do |user|

  orders = user.bro_orders.with_paid_state.order(created_at: :desc)

  master_order = orders.first

  slave_orders = orders.where.not(id: master_order.id)

  if slave_orders.any?

    slave_orders.each do |order|

      order.line_items.each do |li|
        master_order.line_items.create(
                variant: li.variant,
             unit_price: li.unit_price,
          bro_sale_name: li.bro_sale_name,
           product_name: li.product_name,
               position: li.position,
                  color: li.color,
           variant_name: li.variant_name,
               approved: li.approved
        )
      end

      order.cancel!
    end

  end

end