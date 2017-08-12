class PagesController < ApplicationController

  # GET /krew
  def krew
    render layout: 'containerless'
  end

  # GET /shipping
  def shipping; end

  # GET /returns-exchanges
  def returns; end

  # GET /about
  def about; end

  # GET /terms
  def terms; end

  # GET /privacy
  def privacy; end

end