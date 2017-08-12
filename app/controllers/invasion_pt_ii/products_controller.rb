class InvasionPtIi::ProductsController < ApplicationController

  def show
    @sale     ||= BroSale.find_by(slug: 'invasion-pt-ii')
    @product  ||= BroProduct.find_by(slug: params[:slug])
    @images   ||= @product.images.sorted
    @variants ||= @product.variants.sorted.active.visible

    render layout: 'invasion_pt_ii'
  end

end