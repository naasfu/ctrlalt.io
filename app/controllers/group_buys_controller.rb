class GroupBuysController < ApplicationController

  # Setup @group_buy.
  before_action :set_group_buy, only: [:show]

  # GET /buys
  def index
    # Setup @group_buys as collection.
    @group_buys ||= GroupBuy.active.visible.by_deadline
  end

  # GET /buys/:slug
  def show
    # Setup @group_buy relationships as collections.
    @products   ||= @group_buy.sorted_products
    @images     ||= @group_buy.images
    @microposts ||= @group_buy.microposts.newest

    render layout: 'containerless'
  end

private

  # Setup @group_buy.
  def set_group_buy
    @group_buy = GroupBuy.includes(:images, :microposts, sorted_products: [:sorted_variants, :sorted_images]).find_by(slug: params[:slug])
    # @group_buy = GroupBuy.find_by(slug: params[:slug])
  end

end
