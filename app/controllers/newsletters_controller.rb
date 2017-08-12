class NewslettersController < ApplicationController

  # GET /newsletters
  def index
    # Setup @newsletters for collection.
    @newsletters ||= Newsletter.has_been_sent.newest
  end
  
  # GET /newsletters/:slug
  def show
    # Setup @newsletter.
    @newsletter ||= Newsletter.find_by(slug: params[:slug])
  end

end