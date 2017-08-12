class Invasion::NightstalkerController < ApplicationController

  def index
    render layout: false
  end

  def show
    @sale         ||= BroSale.find_by(slug: 'nightstalker')

    @nightstalker ||= @sale.products.find_by(slug: 'reaper-n5-nightstalker-armor-collectors-edition')
    @variants     ||= @nightstalker.variants.sorted

    @reaper       ||= @sale.products.find_by(slug: 'reaper-n5-nightstalker-armor')

    redirect_to root_url, error: "The invasion is about to begin." unless @nightstalker
    
    render layout: false
  end

end