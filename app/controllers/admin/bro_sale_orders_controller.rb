class Admin::BroSaleOrdersController < Admin::AdminController
  before_action :set_bro_sale

  include BroOrderSearch

  def index
    @bro_orders = search_orders(params, @bro_sale.orders.sorted).page(params[:page])
    @products   = @bro_sale.products.sorted
  end

private

  def set_bro_sale
    @bro_sale = BroSale.find_by(slug: params[:bro_sale_slug])
  end
end
