class Reapersngamers::ReapersngamersController < ApplicationController

  def show
    # Sale
    @reapersngamers = BroSale.find_by(slug: 'reapersngamers')

    # Make sure the sale is ready
    redirect_to root_url unless @reapersngamers
    
    # All bros
    @bros           = @reapersngamers.products

    # Reaper Classic
    @reaper_classic = @bros.find_by(slug: 'reaper-classic')

    # Gamer kits
    @gamer_kits     = @bros.where.not(id: @reaper_classic.id).sorted

    # Custom layout
    render layout: false
  end

end