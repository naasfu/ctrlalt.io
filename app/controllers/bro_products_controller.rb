class BroProductsController < ApplicationController

  # GET /bro-caps/:slug/product/:product_slug
  def show
    @bro_sale ||= BroSale.find_by(slug: params[:slug])
    @product  ||= BroProduct.find_by(slug: params[:product_slug])

    render layout: false
  end

end