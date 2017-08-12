class Home::HomeController < ApplicationController
  def index
    @group_buy_count ||= GroupBuy.active.visible.count
    @bro_sale_count  ||= BroSale.active.visible.count
    @kwk_sale_count  ||= KwkSale.active.visible.count
  end

private

  def set_store
    @store = GroupBuy.find_by(slug: 'store')
  end
end
