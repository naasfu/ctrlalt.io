class Fourtwenty::FourtwentyController < ApplicationController

  def show
    # Sale
    @fourtwenty = BroSale.find_by(slug: '420')

    # Make sure the sale is ready
    redirect_to root_url unless @fourtwenty
    
    # All bros
    @bros = @fourtwenty.products.sorted

    @reapers = @bros.limit(4)
    @featured_reaper = @reapers.first

    @jolly_rogers = @bros.offset(4).limit(7)
    @featured_jolly_roger = @jolly_rogers.first

    @stumps = @bros.offset(11).limit(4)
    @featured_stump = @stumps.first

    @gamer_sets = @bros.offset(15)
    @featured_gamer_set = @gamer_sets.first

    # Custom layout
    render layout: false
  end

end