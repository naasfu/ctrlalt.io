class InvasionPtIi::CorruptedController < ApplicationController

  def index
    @sale ||= BroSale.find_by(slug: 'invasion-pt-ii')
    @products ||= @sale.products.sorted

    render layout: 'invasion_pt_ii'
  end

  def show
    @sale = BroSale.find_by(slug: 'corrupted')

    @products = @sale.products.sorted

    redirect_to root_url, error: "Get out." unless @sale

    render layout: false
  end

end