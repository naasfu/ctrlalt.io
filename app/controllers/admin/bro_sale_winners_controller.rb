class Admin::BroSaleWinnersController < Admin::AdminController
  before_action :set_bro_sale

  include BroOrderSearch

  def index
    @bro_orders = search_orders(params, @bro_sale.orders.winners).order(geekhack_username: :asc)
    @products   = @bro_sale.products.sorted
  end

private

  def set_bro_sale
    @bro_sale = BroSale.find_by(slug: params[:slug])
  end
end
