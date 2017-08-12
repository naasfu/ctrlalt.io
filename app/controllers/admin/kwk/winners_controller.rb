class Admin::Kwk::WinnersController < Admin::AdminController
  before_action :set_sale

  include KwkOrderSearch

  def index
    @orders = search_orders(params, @sale.orders.winners.sorted).page(params[:page])
  end

private

  def set_sale
    @sale ||= KwkSale.find_by(slug: params[:slug])
  end

end
