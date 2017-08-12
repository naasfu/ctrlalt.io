class KwkSalesController < ApplicationController

  # Setup @kwk_sale.
  before_action :set_kwk_sale, only: [:show]

  # GET /kult-worship-kaps
  def index
    # Setup @kwk_sales.
    @kwk_sales ||= KwkSale.includes(sorted_products: [:sorted_variants]).active.visible.by_deadline

    render layout: 'containerless'
  end

  # GET /kult-worship-kaps/:slug
  def show
    # Setup @products.
    @products ||= @kwk_sale.sorted_products

    render layout: 'containerless'
  end

private
  
  # Setup @kwk_sale.
  def set_kwk_sale
    @kwk_sale ||= KwkSale.includes(sorted_products: [:sorted_variants]).find_by(slug: params[:slug])
  end

end
