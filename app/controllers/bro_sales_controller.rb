class BroSalesController < ApplicationController

  # Setup @bro_sale.
  before_action :set_bro_sale, only: [:newsletter, :show]

  # GET /bro-caps
  def index
    # Setup @bro_sales as collection.
    @bro_sales ||= BroSale.active.visible.by_deadline
  end

  # GET /bro-caps/:slug
  def show
    # Setup @bro_sale relationships as collections.
    @products ||= @bro_sale.products.visible.active.sorted
    @images   ||= @bro_sale.images.sorted

    render layout: 'containerless'
  end

private

  # Setup @bro_sale.
  def set_bro_sale
    @bro_sale ||= BroSale.find_by(slug: params[:slug])
  end

end