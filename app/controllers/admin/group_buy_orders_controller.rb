class Admin::GroupBuyOrdersController < Admin::AdminController
  before_action :set_group_buy

  include OrderSearch

  def index
    @orders   = search_orders(params, @group_buy).page(params[:page])
    @products = @group_buy.products.sorted
  end

private

  def set_group_buy
    @group_buy = GroupBuy.find_by(slug: params[:group_buy_slug])
  end
end
